Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC9F31A802;
	Wed, 17 Sep 2025 12:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112746; cv=none; b=Slpk8z92i+aJ6E709vaN4lG9B8ONRYHHQ8BCRWZutb04y2vCc2QMpJWzo3Qcz9Qm73sA1eCLQI1Iw4r8rGDtzD4BHQY5blGcRfVXDhpXrtsO+ubDRO+wh6pLfk2COeLUX7DKK+1pN6HeP6AZ+XRMdx3EEGbyzQmgeN8/QmrpOA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112746; c=relaxed/simple;
	bh=7nRY5HU4XRsfbDkyx7nzE5wMXJrBp5d2M6GeOdqO1Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iUu5MAzOO4BvBCIHamCPn0LTpHgtLzhIHPGX7ir8GbziSnfxS+Dk26sGsv1FEYt89T1HELblkJW/ReES+1YhXz8VP60fZpyBNXmupVjjeulFJP/LQz1Xqp9yp+jMf2O8mbQwcRJv+WObDe9wUg/kCRMxrGx1QU+z7dMBw7QAJ6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAL9VfGz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAL9VfGz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D49C4CEF0;
	Wed, 17 Sep 2025 12:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112746;
	bh=7nRY5HU4XRsfbDkyx7nzE5wMXJrBp5d2M6GeOdqO1Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAL9VfGzfGsowANVTwNSXOB6T2JZFjIvA2gVs0KCguuK3UadLBFegv4R8m48F1GMK
	 iX4vmwJN08+LdWgZTrqCfa2Uhz+C1eBIzXsRdbEH+WPOzdhKT9WUi0yS9rw9bEN3/d
	 vgWz1JfCVeTJy12rWlRoG7WPkFx77lDbFJ47T0Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Brandt <todd.e.brandt@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: [PATCH 6.16 065/189] PM: hibernate: Restrict GFP mask in hibernation_snapshot()
Date: Wed, 17 Sep 2025 14:32:55 +0200
Message-ID: <20250917123353.459941800@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 449c9c02537a146ac97ef962327a221e21c9cab3 upstream.

Commit 12ffc3b1513e ("PM: Restrict swap use to later in the suspend
sequence") incorrectly removed a pm_restrict_gfp_mask() call from
hibernation_snapshot(), so memory allocations involving swap are not
prevented from being carried out in this code path any more which may
lead to serious breakage.

The symptoms of such breakage have become visible after adding a
shrink_shmem_memory() call to hibernation_snapshot() in commit
2640e819474f ("PM: hibernate: shrink shmem pages after dev_pm_ops.prepare()")
which caused this problem to be much more likely to manifest itself.

However, since commit 2640e819474f was initially present in the DRM
tree that did not include commit 12ffc3b1513e, the symptoms of this
issue were not visible until merge commit 260f6f4fda93 ("Merge tag
'drm-next-2025-07-30' of https://gitlab.freedesktop.org/drm/kernel")
that exposed it through an entirely reasonable merge conflict
resolution.

Fixes: 12ffc3b1513e ("PM: Restrict swap use to later in the suspend sequence")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220555
Reported-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Tested-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Cc: 6.16+ <stable@vger.kernel.org> # 6.16+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/hibernate.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -423,6 +423,7 @@ int hibernation_snapshot(int platform_mo
 	}
 
 	console_suspend_all();
+	pm_restrict_gfp_mask();
 
 	error = dpm_suspend(PMSG_FREEZE);
 


