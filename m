Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE34546444;
	Tue, 10 Sep 2024 10:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964056; cv=none; b=n4WRqAe9yt5/53iACz1ZoetE7VbXlk2wc97uraFq6vPSkM6ERKWK6CmhBnVNywK68g7zVCq45nH2x+yKnLIDXJ7PPtEP9R4GjtSkhyQaLy+HwlW4DSneLR5wrA9OkxLs1Bjl1sNg8eMsNckPSdntt3KcdVp13fm6CiHMzltdxo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964056; c=relaxed/simple;
	bh=tVS2r6GPdhy6NLRrGgxk6vcY66mfUmR3m/ykAAJkdMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEd9hqBspFZAAtb4HsiU+I7NVzap0YG2+VrrcP7uCUM9akGu0HRiIYHb8px1NPH/FMY0cm9bGk9L7uEEVdCetgfVDjgd/irdxb10Ea6w73e3YJ4x+pNYz6uYTLZmTgNskopgbYVQOlDao/3WyLX1zLd2ZuIezFZSL3ep/N/Dxzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bk988elG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bk988elG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74834C4CEC3;
	Tue, 10 Sep 2024 10:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964055;
	bh=tVS2r6GPdhy6NLRrGgxk6vcY66mfUmR3m/ykAAJkdMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bk988elGzOrO9bBKARxM4brm5aB+2UrdF5ZceUu8fHUpsfzBuJJUdd4SyHw2XJSJd
	 0oI3pHk3SgJwH3ScMLnU2ebM1F0NHP4JBVorJvYVMtWd+IX1HDM9ab1Ma/MzL594gz
	 3kjiXh0By3j1zGghDmS+D3b8ECrUYXpzqq+zoUjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <yuntao.wang@linux.dev>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 052/269] x86/apic: Make x2apic_disable() work correctly
Date: Tue, 10 Sep 2024 11:30:39 +0200
Message-ID: <20240910092610.093202438@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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
@@ -1812,12 +1812,9 @@ static __init void apic_set_fixmap(bool
 
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
@@ -1830,6 +1827,10 @@ static __init void x2apic_disable(void)
 	}
 
 	__x2apic_disable();
+
+	x2apic_mode = 0;
+	x2apic_state = X2APIC_DISABLED;
+
 	/*
 	 * Don't reread the APIC ID as it was already done from
 	 * check_x2apic() and the APIC driver still is a x2APIC variant,


