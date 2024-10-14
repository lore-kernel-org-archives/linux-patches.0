Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252951A76A5;
	Mon, 14 Oct 2024 15:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918636; cv=none; b=Eh5wfXdGGIRO/PEj4469uojmw1yUuXrRQbNMLffsqUFVj/ykStt5x4oXy89EM9+h0PFX/u1b42P8ttnQqdzMLX7jAWaHtP76g6FGQPgu3UE+PorDipyYmbFwP4N5NV7akmnGRSymZkND93lOqy91sQOihGH+FnJp4yWEOf7dEVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918636; c=relaxed/simple;
	bh=d5rpYQ485kr/M1r8hhaI6GUOMaHmkExswL3axvPXzsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0kj5dqDUupyrWjQisrxoijPqTngbhPx7d3LYPMQE9CqFhWLY81FKHTQYcgOKxtOKISPZGoqUsUluA5BQmPRmmX+Uvb8qQlvyAYv7aHUBO0YEgHUa4o432/LMMLzzSgdjojn4bSAur8IrHCNP6/89o7am8rSVLgHOn65dHWOblg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/5CN8yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/5CN8yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D87C4CEC3;
	Mon, 14 Oct 2024 15:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918636;
	bh=d5rpYQ485kr/M1r8hhaI6GUOMaHmkExswL3axvPXzsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/5CN8yyvXKbjF3yUmM8CdOoB23jHpJetCh9zXEve5yGVq+TViTiToBE2HRM5W7NO
	 4PnwTgw71wwc3aWR0svQe9P8gO54jjGQR2qugL/5Jrl7F5WvFePJaJhOjvsgbpp0vh
	 10l5Nk8JNr9k1531TaPMeQq/1jmQ1zZGWim0Cdmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 378/798] static_call: Replace pointless WARN_ON() in static_call_module_notify()
Date: Mon, 14 Oct 2024 16:15:32 +0200
Message-ID: <20241014141232.803989008@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit fe513c2ef0a172a58f158e2e70465c4317f0a9a2 ]

static_call_module_notify() triggers a WARN_ON(), when memory allocation
fails in __static_call_add_module().

That's not really justified, because the failure case must be correctly
handled by the well known call chain and the error code is passed
through to the initiating userspace application.

A memory allocation fail is not a fatal problem, but the WARN_ON() takes
the machine out when panic_on_warn is set.

Replace it with a pr_warn().

Fixes: 9183c3f9ed71 ("static_call: Add inline static call infrastructure")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/8734mf7pmb.ffs@tglx
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/static_call_inline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/static_call_inline.c b/kernel/static_call_inline.c
index 075194d9cbf5b..6f566fe27ec1d 100644
--- a/kernel/static_call_inline.c
+++ b/kernel/static_call_inline.c
@@ -442,7 +442,7 @@ static int static_call_module_notify(struct notifier_block *nb,
 	case MODULE_STATE_COMING:
 		ret = static_call_add_module(mod);
 		if (ret) {
-			WARN(1, "Failed to allocate memory for static calls");
+			pr_warn("Failed to allocate memory for static calls\n");
 			static_call_del_module(mod);
 		}
 		break;
-- 
2.43.0



