Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD73327FD74;
	Mon, 17 Aug 2026 14:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976477; cv=none; b=LZ7Z4iuRM++Adb52vqs9JQzsZeqWsYFOU+BmsWNw2lou2PJVVOV6u90W37HvyNVFy5zp25r1ZQm4DFsyS8Byy4U9ocUcbku6fl/yXvlE1OlnoAaAtknCnjWy0kDSm3BQoYm7jQjbP7lG/N6NFxlLe6X8Wes/QpwksLOFjKBgVZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976477; c=relaxed/simple;
	bh=T1nOtUcqq6ADCUt6qlgXd9rdF/CPzqv005vrC4zc1/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjYx/4AFQNSBW4zNxc47Mf4E5xu99HJoeCFY5ryRRuT+V00s4giNt8GQTjxmbD6kZsoIM48PvcXqAWIMV/zJtVxztKHuAvpIWAzX0f3hDkJ3o3xJWVE/AIaZwQtQUYzp/0EmJTt7i8dcwbmnhbdH3wD3usvR1DB55VAqGA49vzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZyAcniKQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyAcniKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177491F000E9;
	Mon, 17 Aug 2026 14:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976476;
	bh=0deHSM5oKc3HVNj11oyKzDksYsMLxTSlmC55hquMgPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZyAcniKQjloCoIaxM7F34umRjEUqBfaA0xC/L0NLlkl6uxNbtDi1nPIJhO4t+B4bP
	 8ZEeNe3tVYiJZDQv/sXkETWe4ZTEq++HkMrJw1c9vW+f9Dd76ljXz6/Hb4FDqiPEqM
	 v9PCyY0ra1lCee8UWvcgBxuqQ82O5LaOOpSoPhfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 386/389] thunderbolt: Bound the DROM dual link port number before indexing sw->ports
Date: Mon, 17 Aug 2026 15:33:45 +0200
Message-ID: <20260817132553.712241943@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -367,9 +367,16 @@ static int tb_drom_parse_entry_port(stru
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


