Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE75D4399F8;
	Mon, 17 Aug 2026 14:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978322; cv=none; b=jKIl04JMpXVMFRWyty9sciBC1n4dV4id+tZlp5xnrJPd1W7kp+tk2BnP3RKWGLVfvY6twwRHDnE2ug3gu2npxQ3YO3KjbVlPj84RQVO0IouXtOiX21FZ8aV/bsP/BBcJR3jd4CHWdS1COzjzzbzfTzMMIN12CT4mUePWECXlReI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978322; c=relaxed/simple;
	bh=E2LmOXB/O9IOt9IpvEWwmGKPzsXtpsuzeK2vb30+278=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uf5bwP5U7OznD4KxSdcXtyZHoSIoQsXa4xYoP7r7+t5mLMsL7JW6IDqxmtQWGt5ZULVIpa6dCPMp2Y/aGOvVZLHElhn/Z3znoh43UopFTe0F89P7e7OVC8zxNwuQolW7xFSi80V7yPgOPvoL4YSsjpp0TV4CFb664HRzCjZ2GR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrmUDgzD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrmUDgzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2A61F000E9;
	Mon, 17 Aug 2026 14:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978321;
	bh=ZXR+dUrql416Iphx6MT77zBPnGrgBW175bQmxwhugTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nrmUDgzD7fxXC86KD11uqACgJTSVT4Mga+APwP1Q/qwWJ6XR+tq99kZPs1P81R4SD
	 FwcS0bZZxTwXAh/D+2/TvdDsNE8GLjh/myjyQ+wZWHlzNxq4FVxKGIc1nro6enJP62
	 5suG3UsQw+3yxFIw/yDAcKhNO0AsPsHPVvDG3JCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.12 179/181] thunderbolt: Bound the DROM dual link port number before indexing sw->ports
Date: Mon, 17 Aug 2026 15:34:33 +0200
Message-ID: <20260817132542.742978951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -392,9 +392,16 @@ static int tb_drom_parse_entry_port(stru
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


