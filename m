Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5F3437124;
	Mon, 17 Aug 2026 13:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974633; cv=none; b=rFlPeU4HCtucw5Mr9gJRTEeyEie7QCyOrv8T8v18PL2rvIz6BHQuylVa1gmPICQnpkjfWAvbwjHpOxE9gaE3f0fSB+U3RuJ9Y7DdtC+iCgLEQ+O/1ZnUNr15d+UKabrRxgDuSL0jqtP0s36nu3BVB+hfaWytQrVGePGKMcq7ACQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974633; c=relaxed/simple;
	bh=T00C76i8kOkeIXyDQ3fKoNaCnUTjQRFfWQZArsqKXhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPuA6opwms0MWo2TQQ5kYkoAZCXnapCiDX0JpbLtNZkWEiQcHVvTe8M+ByuJ/mDQ+prm6xaBOOP3TZznGVB7ZzD2loaKqf85w5pK4Imm+GXNXC9DXKS+S3i4F3c8uNEfO0guHrMq05bkZG8ne82k2VxNax5WcnBQfO4FRLfkjUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0N3eRVYw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0N3eRVYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821A51F00A3D;
	Mon, 17 Aug 2026 13:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974626;
	bh=H+EKK45wq5X0uDl6Xq++xYfbl2ArHag38de41j22Kt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0N3eRVYw7kOYJUR3JaVqngfALgjvhxpH6W2E7Lzo0hZqNTojSX/VYcIcm2p+xXMzd
	 17F/Zh6zPCAd3I55DIq3kBENUvy6qNZZbjz2HTI7P+ySjI5a1Ubn37gnxuqNsKZz9m
	 X883OOKLL+vYoSI9nmthK5SpE7vmllILFfTBENW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 7.1 270/271] thunderbolt: Bound the DROM dual link port number before indexing sw->ports
Date: Mon, 17 Aug 2026 15:33:15 +0200
Message-ID: <20260817132547.812435027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit d6764992f17b23d91ff93ce905ab53c2aa7191f0 upstream.

tb_drom_parse_entry_port() validates the device-supplied header->index
against sw->config.max_port_number before indexing sw->ports[], but the
sibling field entry->dual_link_port_nr -- a 6-bit value also read from
the DROM -- indexes the same array with no such check. A malicious or
malformed Thunderbolt device can set dual_link_port_nr beyond the
allocated sw->ports[] (max_port_number + 1 entries), producing an
out-of-bounds tb_port pointer that is stored and later dereferenced.

Reject a port entry whose dual_link_port_nr exceeds max_port_number,
the same bound already applied to header->index.

Fixes: cd22e73bdf5e ("thunderbolt: Read port configuration from eeprom.")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/eeprom.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -394,9 +394,16 @@ static int tb_drom_parse_entry_port(stru
 			return -EIO;
 		}
 		port->link_nr = entry->link_nr;
-		if (entry->has_dual_link_port)
+		if (entry->has_dual_link_port) {
+			if (entry->dual_link_port_nr > sw->config.max_port_number) {
+				tb_sw_warn(sw,
+					"port entry has invalid dual link port number %u\n",
+					entry->dual_link_port_nr);
+				return -EIO;
+			}
 			port->dual_link_port =
 				&port->sw->ports[entry->dual_link_port_nr];
+		}
 	}
 	return 0;
 }


