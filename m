Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BA03E5EC0;
	Mon, 17 Aug 2026 14:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978775; cv=none; b=fnQUVPllSBPzZ7DJks4A/bObYV5Fg6vM5ZSSW0svETEcT30jc76nKceRZ3qPzUjYRoXk2zO7/RNNoTFJV2YeQ41pMiUGcmD2lEdAiwlhTZuE5m7KYsZx68tPd3Vrkd7W45VXXscu2u+Lb6PFy36T+LQ99JjZThEi+E7ToRFb70U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978775; c=relaxed/simple;
	bh=FeEavSU1X8RQttdRuwfy4OyOXW5rrPj+KZAkNlATy/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPpKMd70Fu2SEi4GfJKln2AtIc7IyfvIqzF5z16Qe5PR/Vrd+wiMPIMQgvaEGYH+2A9mYnVLSUGpJF4HPBaVlQ1GOi6J/0VRNMJXMbBJcH53jN3BFS+tW5eTvtvehXBADXbd3W2S7KJAVuBCEzeN1kifEN8FduZmCQaDGoutc1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZVnT2QT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZVnT2QT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F91D1F000E9;
	Mon, 17 Aug 2026 14:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978774;
	bh=gsqiGshzydAUCY8P2/nRnsGqEZuOir4t7aT8/MdgT1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eZVnT2QTrDVhQgVyR8YRoldRe0ZVLpIcVoT9bhMJOtyl0Lx5mWecvf2vUzoNW5iJR
	 kpW0vZwtdss066NJt8UHtsIZ9vj4PUTtaIkUcSGwc1L5On6ZhGtOJ1ORCeBF4Nw/AC
	 wWp0g2s+7UMqVMxJu2EAFBc692Th0vJJcY6dD9F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 152/156] thunderbolt: Bound the DROM dual link port number before indexing sw->ports
Date: Mon, 17 Aug 2026 15:34:46 +0200
Message-ID: <20260817132540.703367993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


