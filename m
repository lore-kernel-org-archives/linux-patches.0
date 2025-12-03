Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE0F34A79E;
	Wed,  3 Dec 2025 16:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777670; cv=none; b=OlAj6i6B0gztDpo4RDB8l1pi+sDumPH/VAYxxJ9PnCDwYf00DkgHc0EACHR4NbO7v3a5HWVarxlsmkGPlTuAiPMeknRm0s52Cgex3JgOSzxBlxJ/xif0mMS9VGwoN4bWn20MX0zS8I/XXi0PcGzkqZIjKHH2Fz7DUkkZYyDQ9kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777670; c=relaxed/simple;
	bh=36+qM03Pa0Pl5bxmk9pSM1z7E+oitXUzQGi3klXkS14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEoe2yR8OEBHAn0H9VBnsEwcSbD66lzJNatevgrzXEEw3UV3e8iGH7VnkNyNHCWRnzvkzLF1g07rdRfT1M0kKvAv6yXzF4V6LK3q9fbAqcFYBktxiLGhQFpJopn6IPsduQLY0JDSF5AQC6osgZvxfoWTtXnSe7+/HK6r0/NsB5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYLJoAAj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYLJoAAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73C9C4CEF5;
	Wed,  3 Dec 2025 16:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777670;
	bh=36+qM03Pa0Pl5bxmk9pSM1z7E+oitXUzQGi3klXkS14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYLJoAAjGk5roaa50aGOrDyRpM3cG02c/UQFfDCuMVM2TltstTwWz8lz3VTdBZY7T
	 qjZX4lWg3hU93q2e825Uz/o5rke16KbyA3rhcdltzB17PdK11q6c8IrQcVjQIgxNTN
	 6pszLV1AXkOG1eF2/huGBwwgDm8ex3vrmElX217w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	raub camaioni <raubcameo@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/392] usb: gadget: f_ncm: Fix MAC assignment NCM ethernet
Date: Wed,  3 Dec 2025 16:24:20 +0100
Message-ID: <20251203152418.145142076@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: raub camaioni <raubcameo@gmail.com>

[ Upstream commit 956606bafb5fc6e5968aadcda86fc0037e1d7548 ]

This fix is already present in f_ecm.c and was never
propagated to f_ncm.c

When creating multiple NCM ethernet devices
on a composite usb gadget device
each MAC address on the HOST side will be identical.
Having the same MAC on different network interfaces is bad.

This fix updates the MAC address inside the
ncm_strings_defs global during the ncm_bind call.
This ensures each device has a unique MAC.
In f_ecm.c ecm_string_defs is updated in the same way.

The defunct MAC assignment in ncm_alloc has been removed.

Signed-off-by: raub camaioni <raubcameo@gmail.com>
Link: https://lore.kernel.org/r/20250815131358.1047525-1-raubcameo@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_ncm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_ncm.c b/drivers/usb/gadget/function/f_ncm.c
index 4fe6a1efe0986..1ee950bf1604e 100644
--- a/drivers/usb/gadget/function/f_ncm.c
+++ b/drivers/usb/gadget/function/f_ncm.c
@@ -1468,6 +1468,8 @@ static int ncm_bind(struct usb_configuration *c, struct usb_function *f)
 
 	ncm_opts->bound = true;
 
+	ncm_string_defs[1].s = ncm->ethaddr;
+
 	us = usb_gstrings_attach(cdev, ncm_strings,
 				 ARRAY_SIZE(ncm_string_defs));
 	if (IS_ERR(us))
@@ -1717,7 +1719,6 @@ static struct usb_function *ncm_alloc(struct usb_function_instance *fi)
 		mutex_unlock(&opts->lock);
 		return ERR_PTR(-EINVAL);
 	}
-	ncm_string_defs[STRING_MAC_IDX].s = ncm->ethaddr;
 
 	spin_lock_init(&ncm->lock);
 	ncm_reset_values(ncm);
-- 
2.51.0



