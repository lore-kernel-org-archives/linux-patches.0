Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5374A143882;
	Tue, 23 Apr 2024 21:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908454; cv=none; b=Y18XaJ7o243HUCxl6P9uMym1QWQvU5+L3Oz8tH1hL6LoQ9vi+Sr7dLc+aReRj4eYB2R1nYaMUrLiMVFDe2rzbfRiemm/fP9hd9/pWI7fZyNcYOTKvCzaQkBBTjWbS6VJWgySj6Dwkq51Glh3ECmInDC4GnJHqfJHSSb/4rH3zf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908454; c=relaxed/simple;
	bh=VWdHFBXghY2iJusz44HDATzTPy4gpWGAN5/M7VtfVac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADh9cpNAuQ1ELnyOkKfNv1va0Anrbar3NDgoOcauqZOZh7jRwON8XEznEk61U0Ne8J2Rlcz4AM/2RWIWeq0lEXMUsizO/NKfDz6j5uwLQpyQcNFxM5rQoY+qPRhSffsihCuGm55R8udwKbiCH66X+jIsC1Q5GRh5JNVtJPChs9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z37FnURp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z37FnURp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9708C32786;
	Tue, 23 Apr 2024 21:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908453;
	bh=VWdHFBXghY2iJusz44HDATzTPy4gpWGAN5/M7VtfVac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z37FnURp7J8BtYy9y1VYnPgmVfLyzJVcZMUSvgMkUuGZWwhLCh8bWZMrLya4dk3z4
	 8QLeiHYdePr2AlEEP5FpRhbh1gplddvfzDUq7vOM1POy+Yvl2ikRR9Yp+9NT5ZiLh0
	 G1DyPkOZVLk05GATtfw6QX1w+Kdd0tXRRKLMD/8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 012/158] r8169: add missing conditional compiling for call to r8169_remove_leds
Date: Tue, 23 Apr 2024 14:37:14 -0700
Message-ID: <20240423213856.243814697@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 97e176fcbbf3c0f2bd410c9b241177c051f57176 upstream.

Add missing dependency on CONFIG_R8169_LEDS. As-is a link error occurs
if config option CONFIG_R8169_LEDS isn't enabled.

Fixes: 19fa4f2a85d7 ("r8169: fix LED-related deadlock on module removal")
Reported-by: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Tested-By: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Link: https://lore.kernel.org/r/d080038c-eb6b-45ac-9237-b8c1cdd7870f@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4932,7 +4932,8 @@ static void rtl_remove_one(struct pci_de
 
 	cancel_work_sync(&tp->wk.work);
 
-	r8169_remove_leds(tp->leds);
+	if (IS_ENABLED(CONFIG_R8169_LEDS))
+		r8169_remove_leds(tp->leds);
 
 	unregister_netdev(tp->dev);
 


