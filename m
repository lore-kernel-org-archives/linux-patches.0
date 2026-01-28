Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36572D0C62;
	Wed, 28 Jan 2026 15:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614598; cv=none; b=pKAPswEtXwvx7zk5/BEOGMTrVEw1IZaSiMrUvqya8MfcKqlP43xa5RB0oB+rv9VNLKoYB5ljATdELdYzSlPT6Ddi7T4DhU9tcV6Js5ShDNkhDHVoqhnxAwll5xYspGQnlREw1lf4cm/iKSU8ZQg2/0KTWi1d3EvaSVyaXVuzPzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614598; c=relaxed/simple;
	bh=mEOjuoiQwgV4KtbHMonZxgGvj96FSO+j0Emc3xl6+WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MS8S/dzVlP6rkGIlCAXqV7ttzlt1yTDnyGFm7J31/FkSb50SEly8UodobypvCSRq0paoQnEn8fecfgGlSc2peVN8Gwiqk8gBWI9ChnOYEi8syngngxEdpjiFOHXpQuKxO4fY7TJYI5KmqjP70NSkvrsdnrlar6FdZPG5IzGwwOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4qeZdpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4qeZdpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF9CC4CEF1;
	Wed, 28 Jan 2026 15:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614598;
	bh=mEOjuoiQwgV4KtbHMonZxgGvj96FSO+j0Emc3xl6+WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4qeZdpfgiMU8XD7ihQzrxZEr0bKdmb16NxzMeIygK0Kdbfzd4nlsEZJUAcVElqhj
	 vsh7+OqxHWGFvWa9B5cWvqHb8hfPomOpeo1TuEbZ+697m4ZqMyQGos8AYRvIeIcQ3G
	 VUZlw/SG+vIq8QRsh+/HCCeweRNeO/4Ea34SY/+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 186/254] of: platform: Use default match table for /firmware
Date: Wed, 28 Jan 2026 16:22:42 +0100
Message-ID: <20260128145351.495631938@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Rob Herring (Arm) <robh@kernel.org>

commit 48e6a9c4a20870e09f85ff1a3628275d6bce31c0 upstream.

Calling of_platform_populate() without a match table will only populate
the immediate child nodes under /firmware. This is usually fine, but in
the case of something like a "simple-mfd" node such as
"raspberrypi,bcm2835-firmware", those child nodes will not be populated.
And subsequent calls won't work either because the /firmware node is
marked as processed already.

Switch the call to of_platform_default_populate() to solve this problem.
It should be a nop for existing cases.

Fixes: 3aa0582fdb82 ("of: platform: populate /firmware/ node from of_platform_default_populate_init()")
Cc: stable@vger.kernel.org
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://patch.msgid.link/20260114015158.692170-2-robh@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/platform.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -616,7 +616,7 @@ static int __init of_platform_default_po
 
 		node = of_find_node_by_path("/firmware");
 		if (node) {
-			of_platform_populate(node, NULL, NULL, NULL);
+			of_platform_default_populate(node, NULL, NULL);
 			of_node_put(node);
 		}
 


