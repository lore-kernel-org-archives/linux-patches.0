Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C6F35CB60;
	Fri,  7 Aug 2026 15:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115953; cv=none; b=Y2mqI6TO5om2d2/zPiz+MJJX6BP5kCzzzXJ9uqQ0cwVPKstcjE5ue1dbIciIFCBC8Ko9C9kq4EsD9O0ofSvy/FHMiHFzdlKkRsvyyXOgFefPeuHybOSAC2RS1vNC1Y3GNC17kApar2YXUPxPpXPhzvbYEPKzSCxGICNqhDNJnw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115953; c=relaxed/simple;
	bh=u6YaRaCCmmZoklNYvPHsmKyEI5ePuWSljrj1MIccPak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPwDUBcps3lpmwuqJ2ZemkXFotQug2Q+D5lq8e/66fZGDTH3o5SDgO9VhlmFYh0RUbSP7CeoGPppDgkVdXVL8sXzC3UQZ1VYN+KX4XWMIoy4c7P8nyOLP40WiqqzHnof1sqTKlpZ/VpiqX6gHQb/nAirug1IbCUZncMcNK9QbXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWlLP6HI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWlLP6HI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E12A1F000E9;
	Fri,  7 Aug 2026 15:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115952;
	bh=X2UeiWPw95ugoJ9lBWo6RwI88q/XqajT4soPeUlwBwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OWlLP6HIdWGaICk0n2SJvGLptpAX5+a5IzvVhMxcKXbLrNdB70Rdo8a7VeWdGQTd6
	 IzD+CgUpk82GXHPUw59DO7tHdhdo3A3TLb4PP/iQDjYyhK1dZ9JtZqmPzm/5p4kXKv
	 MqezoujpTR+DaC39ehJJVAMtgIESlahpZO/en5IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/261] powerpc/boot: Fix simpleboot CPU node lookup check
Date: Fri,  7 Aug 2026 16:36:55 +0200
Message-ID: <20260807143416.635975546@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit c824ab65685bb119c6c6a3a200b3428c72862d5a ]

fdt_node_offset_by_prop_value() returns a negative error code on
failure - fix the check accordingly.

Fixes: d2477b5cc8ca ("[POWERPC] bootwrapper: Add a firmware-independent simpleboot target.")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260702211554.56923-4-thorsten.blum@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/simpleboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/simpleboot.c b/arch/powerpc/boot/simpleboot.c
index c80691d83880b..27591df41e9e8 100644
--- a/arch/powerpc/boot/simpleboot.c
+++ b/arch/powerpc/boot/simpleboot.c
@@ -68,7 +68,7 @@ void platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	/* finally, setup the timebase */
 	node = fdt_node_offset_by_prop_value(_dtb_start, -1, "device_type",
 					     "cpu", sizeof("cpu"));
-	if (!node)
+	if (node < 0)
 		fatal("Cannot find cpu node\n");
 	timebase = fdt_getprop(_dtb_start, node, "timebase-frequency", &size);
 	if (timebase && (size == 4))
-- 
2.53.0



