Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625D5133987;
	Tue, 20 Feb 2024 21:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463517; cv=none; b=O+k3AqMBN7fS+dlYcSGo2fffOYP9sGN+13pMnBGePApvU3t/Vel+ph/adMT8kG5ujBrcHtXDQLn8qNNERXFx1+YB2sljrgfl88C6vUGYEkJp56/ScHEqlxCBD6+0sGqwEu2MJdEfZAUT069C4T5HGcxIfJiimn2gj4CHibNx+1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463517; c=relaxed/simple;
	bh=njQ3FGvZdEVcGhzMV7k92pjfegfHM0UZ7htKeFcmtlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0EUnb6Y/nxr2KqnHbEU1HYf6RkQPTVLhbl7E5/gi6BZuOyxAidj48hTnNhQgNPOSjh1bt5gHMgaxyY1Fa2CH65OxABzU5hedMJW8CFDuD1yXUbLeEBehJfwny41+pvljzeZSPCrZclctKzWvRQ8ig1RetyNqD5wZ9BRbBbH48w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oeMm+Q65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oeMm+Q65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1404C433F1;
	Tue, 20 Feb 2024 21:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463517;
	bh=njQ3FGvZdEVcGhzMV7k92pjfegfHM0UZ7htKeFcmtlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeMm+Q65RimH1moICfjqdrqGGxKpi8Wip9xR7xmT1Ji0g34MDfMp053xtYqw89IhG
	 5NsGPjyLVlsBCf1sTTZfdj061uufQ2leaynEnJoCZE/sHEokY7zUyQijZlZ6yRF7mL
	 KHcdxzKAxfue9AaeRieY9BRB6MKENmqZZQ0LFq54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 068/331] parisc: Prevent hung tasks when printing inventory on serial console
Date: Tue, 20 Feb 2024 21:53:04 +0100
Message-ID: <20240220205639.718345440@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit c8708d758e715c3824a73bf0cda97292b52be44d upstream.

Printing the inventory on a serial console can be quite slow and thus may
trigger the hung task detector (CONFIG_DETECT_HUNG_TASK=y) and possibly
reboot the machine. Adding a cond_resched() prevents this.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/drivers.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -1004,6 +1004,9 @@ static __init int qemu_print_iodc_data(s
 
 	pr_info("\n");
 
+	/* Prevent hung task messages when printing on serial console */
+	cond_resched();
+
 	pr_info("#define HPA_%08lx_DESCRIPTION \"%s\"\n",
 		hpa, parisc_hardware_description(&dev->id));
 


