Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E3818C32E;
	Tue, 10 Sep 2024 09:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961470; cv=none; b=nh5lw1Db+slbIUfeK2n4+FS46Q7QspKyKT3YZVhmJQv8WvYYkUj/xudN17jiAJQ6JRBJlIdVgqi7NukOWn3GPqmnHD/cCaLqwFzYlKwj8hyB4oZvctr7TUbXbRYlUkwYjD22FDwAbdfsd9/b4r0UkMuYRoIMvMEXoWztHb5iEn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961470; c=relaxed/simple;
	bh=t1v7bSrlXKkk1f3U4YQj85vFs++4uhTIlm3juxLSh6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWMveCN8nRh79jTEreg+PYgZFGHHhhlwS1ayQ9gLNSZPgoqntbU20PkuPLm8POkd8th95Rlu0BjYba7Uk+GHC5CgYyyvWtBPPtYF8dX8xm7YCC4/wsEKoyid7vZl+AwFwVC37QMR+LNzypxlLCkWh9eQqudhFL/f1rwlcDJGLwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5kgdUK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5kgdUK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B05C4CEC3;
	Tue, 10 Sep 2024 09:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961470;
	bh=t1v7bSrlXKkk1f3U4YQj85vFs++4uhTIlm3juxLSh6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b5kgdUK4RLGIC+iOt2nPb+zXEOElXiXEsR1WdfrXm9VyXb6P0fxEh5YSYelDO5Lan
	 NTukv3Ed2wink7/rtiEoO9Hv36bOhYxerKebYVTGH4t8oGZ+ELo6oBrj4z3TeiIdSw
	 vY4S7/tw1PWdQGHLj+l/mwNZtk8phTgYo4iHGUaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <yuntao.wang@linux.dev>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.10 073/375] x86/apic: Make x2apic_disable() work correctly
Date: Tue, 10 Sep 2024 11:27:50 +0200
Message-ID: <20240910092624.674818557@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuntao Wang <yuntao.wang@linux.dev>

commit 0ecc5be200c84e67114f3640064ba2bae3ba2f5a upstream.

x2apic_disable() clears x2apic_state and x2apic_mode unconditionally, even
when the state is X2APIC_ON_LOCKED, which prevents the kernel to disable
it thereby creating inconsistent state.

Due to the early state check for X2APIC_ON, the code path which warns about
a locked X2APIC cannot be reached.

Test for state < X2APIC_ON instead and move the clearing of the state and
mode variables to the place which actually disables X2APIC.

[ tglx: Massaged change log. Added Fixes tag. Moved clearing so it's at the
  	right place for back ports ]

Fixes: a57e456a7b28 ("x86/apic: Fix fallout from x2apic cleanup")
Signed-off-by: Yuntao Wang <yuntao.wang@linux.dev>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240813014827.895381-1-yuntao.wang@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/apic/apic.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1775,12 +1775,9 @@ static __init void apic_set_fixmap(bool
 
 static __init void x2apic_disable(void)
 {
-	u32 x2apic_id, state = x2apic_state;
+	u32 x2apic_id;
 
-	x2apic_mode = 0;
-	x2apic_state = X2APIC_DISABLED;
-
-	if (state != X2APIC_ON)
+	if (x2apic_state < X2APIC_ON)
 		return;
 
 	x2apic_id = read_apic_id();
@@ -1793,6 +1790,10 @@ static __init void x2apic_disable(void)
 	}
 
 	__x2apic_disable();
+
+	x2apic_mode = 0;
+	x2apic_state = X2APIC_DISABLED;
+
 	/*
 	 * Don't reread the APIC ID as it was already done from
 	 * check_x2apic() and the APIC driver still is a x2APIC variant,


