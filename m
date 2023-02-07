Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D992C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56A1C433EF;
	Tue,  7 Feb 2023 13:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775175;
	bh=0diB4gK3m4UIbSO8LGaJXTRTVQeqYwtfrhA37jpzZkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnM48AOB5Ud4MSD8bV72VIDT4v8FP/0nxZmcjJvpAPxR/if5OhDGM+pOwR0K2Wnzr
	 MlGUjgijzKxochQcVufF70DrYqUMsoNOWclObNzAhZqkuV7zeljs70dObpBDx91kuC
	 LxPrAOy9zqUpctddkfpTciAlrqKB+3+0z7n/jRbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	stable <stable@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 162/208] kernel/irq/irqdomain.c: fix memory leak with using debugfs_lookup()
Date: Tue,  7 Feb 2023 13:56:56 +0100
Message-Id: <20230207125641.760542147@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit d83d7ed260283560700d4034a80baad46620481b upstream.

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable <stable@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230202151554.2310273-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irqdomain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1915,7 +1915,7 @@ static void debugfs_add_domain_dir(struc
 
 static void debugfs_remove_domain_dir(struct irq_domain *d)
 {
-	debugfs_remove(debugfs_lookup(d->name, domain_dir));
+	debugfs_lookup_and_remove(d->name, domain_dir);
 }
 
 void __init irq_domain_debugfs_init(struct dentry *root)


