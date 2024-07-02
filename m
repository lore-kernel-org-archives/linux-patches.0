Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DC715B0FE;
	Tue,  2 Jul 2024 17:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940495; cv=none; b=Lk76Vrtl2gUlciSGJUiSep7bbfq30Q/wb/Y2+4AZC5NaobXD9AJOOBkYtuXUNL+Q287TT0aw2MKwE1ihEScKtIYo3Bse+uQosmxvCueJ64FD/XlPmQt8xNYaxHkGD9+/nkFAw1PlB7ZNhOr11XhLdFwqOFTDjDz3dwX6FCxhGTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940495; c=relaxed/simple;
	bh=cv7Yy7oztt668SxbI8pl/8CqUTJ2h02wKrdhAuZQeog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwTm2l5tcxFivduhOgTeyu88Wxz5/NicbDhdrYQ08zNE4pkYkbt3gftvLS/LosJviWg6bBAFvznLirg9a8peznzZ1V6Lrk/XswE1kYblyMs8EN+UlQ0nir0xBfL1j9wRrl8/qkBYbQX8aN3JKekVpx0kIWDgbhsDdvqz3ncFWx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlsg7myd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlsg7myd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7749CC116B1;
	Tue,  2 Jul 2024 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940494;
	bh=cv7Yy7oztt668SxbI8pl/8CqUTJ2h02wKrdhAuZQeog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jlsg7mydzHGpySenaPhjygNF/9jq188MDpA/BsSycdtoyUxRU1An8vO8huYYUyZQd
	 gRCticQBx8onSxifWqd6Qo+kvnpTf+ExvKV7ofTfvEQH3AfWHfATrAezKZy/1rojX2
	 zBz98yMDLu1vWB16fEU010/mpO/9KN+EvFaDBitk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.9 171/222] cpu: Fix broken cmdline "nosmp" and "maxcpus=0"
Date: Tue,  2 Jul 2024 19:03:29 +0200
Message-ID: <20240702170250.513173972@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 6ef8eb5125722c241fd60d7b0c872d5c2e5dd4ca upstream.

After the rework of "Parallel CPU bringup", the cmdline "nosmp" and
"maxcpus=0" parameters are not working anymore. These parameters set
setup_max_cpus to zero and that's handed to bringup_nonboot_cpus().

The code there does a decrement before checking for zero, which brings it
into the negative space and brings up all CPUs.

Add a zero check at the beginning of the function to prevent this.

[ tglx: Massaged change log ]

Fixes: 18415f33e2ac4ab382 ("cpu/hotplug: Allow "parallel" bringup up to CPUHP_BP_KICK_AP_STATE")
Fixes: 06c6796e0304234da6 ("cpu/hotplug: Fix off by one in cpuhp_bringup_mask()")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240618081336.3996825-1-chenhuacai@loongson.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cpu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1859,6 +1859,9 @@ static inline bool cpuhp_bringup_cpus_pa
 
 void __init bringup_nonboot_cpus(unsigned int max_cpus)
 {
+	if (!max_cpus)
+		return;
+
 	/* Try parallel bringup optimization if enabled */
 	if (cpuhp_bringup_cpus_parallel(max_cpus))
 		return;


