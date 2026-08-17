Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3912B175A6B;
	Mon, 17 Aug 2026 14:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977803; cv=none; b=Wyo5rs5QiN+ab57aOBNNcBQOx2KeTdXjTvQo4eJmGjl7io3CzdHIyMZkvVGiKMe+64/7ceOD96MipaNJWl1KHybUeFI3CAj9hFWlXydVjBgFNNmZN6JTGbwPI9cy1enqEIW5NXbz6zeVBCzc9gqAfBjt5BNA73q/ZnTO6z4Cb28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977803; c=relaxed/simple;
	bh=wGAxuS/vBGaVzOU11gfCzf4PnPoxnOIwZrcfR11ENy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcjbVGNpXlDh+Zk45+biandb1u1iIuu7RrZzx9yi0W+oDrqd2CiTly5gwadjFaoirVsxj/z3fWkmE0RCKOS2U0Ok7sSUcb5MoB5tF33rd8sBoakp97+5Eevbq7fpCxaMMfyfsuHijSntX9uzVQ/ZOtKVALwWMIi10WuBIqfoA/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDIsj8IO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDIsj8IO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91ADE1F000E9;
	Mon, 17 Aug 2026 14:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977802;
	bh=Fz8eegzEF0H6YSM+6xDt41FXyqO18FzUGFFgD/pJmGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qDIsj8IOF8JFdh1j/L/78Jd3mpblOfz/xmbX+jL3VJBwLn0H41Y3Fj7b+g8QC3Fnm
	 nyGcxFp9JaPA6R/Lmr3j8ivdb8TJ2Bs2qg3CrJmANBwgncugxEyUWYUo4FBcpmeehf
	 yHg5kfQRdthmdJspDO4ErE/THEPKWnYVSXwwsIms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 456/456] thunderbolt: Bound the DROM dual link port number before indexing sw->ports
Date: Mon, 17 Aug 2026 15:34:06 +0200
Message-ID: <20260817132556.828820530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


