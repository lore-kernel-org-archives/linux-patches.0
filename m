Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F71332BF5D;
	Thu, 28 May 2026 19:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998131; cv=none; b=Kkz0KOoyG1MFMp8y0suyqEidwBJ48LJPMy0jfWAlBm5BFwgZ+XOvpfGv7+spSH+aCaO2iK5a7N2RRoZdRkvwkP9n3PzCE9WLRdzRA1Y1C43RQ5mvSx9wASDhvCfmsfxQDI4JXEwRhMfoYoTaEL663CAiZw227yTia2Pds3W2+Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998131; c=relaxed/simple;
	bh=KvvCzeYAcSf4o2XmcaLISZtisUUAleQhrDnAAc+WF7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCfExTEv77ax88Yx2wUXqlrqkNSTlsgtMGYUlNySeP5GmxewRlb09DnW7Jtfq4Sw1SyPH/QDzneQbxBA0+6I+VRY5jBb7Ipfy2IONv4KAoJJULS44A2acLpPToNP3xbmbs2ahHR1aimOgifkLJGFz2L5ZtV88F/Ryj9YjuGUh7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N72wRT+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N72wRT+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEAA1F000E9;
	Thu, 28 May 2026 19:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998130;
	bh=l2ku/9cO69G3Kuuxysd6NxAeMcMdNEB0IgBD2UpNYh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N72wRT+bksoTT/9roxTa8xuKleuvdqtfMnb1/gK80Z0lloqqwgdCbWTvitMDygDLL
	 qLtQ/sy73mr+ODed0x5Gi0ItIdZ8T1lmlyLSQKAEyyVtJNr9l3gx31n492RXu8UyF9
	 5rrQLqpoYHZ9z+dlHkDB+6veKqLRZs3YuFuVljEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuele Mariotti <smariotti@disroot.org>,
	Paolo Valente <paolo.valente@unimore.it>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 064/461] sched_ext: Fix missing warning in scx_set_task_state() default case
Date: Thu, 28 May 2026 21:43:13 +0200
Message-ID: <20260528194648.770684495@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuele Mariotti <smariotti@disroot.org>

[ Upstream commit b905ee77d5f557a83a485b4146210f54f13365fc ]

In scx_set_task_state(), the default case was setting the
warn flag, but then returning immediately. This is problematic
because the only purpose of the warn flag is to trigger
WARN_ONCE, but the early return prevented it from ever firing,
leaving invalid task states undetected and untraced.

To fix this, a WARN_ONCE call is now added directly in the
default case.

The fix addresses two aspects:

 - Guarantees the invalid task states are properly logged
   and traced.

 - Provides a distinct warning message
   ("sched_ext: Invalid task state") specifically for
   states outside the defined scx_task_state enum values,
   making it easier to distinguish from other transition
   warnings.

This ensures proper detection and reporting of invalid states.

Signed-off-by: Samuele Mariotti <smariotti@disroot.org>
Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 9a415cc53711 ("sched_ext: Avoid UAF in scx_root_enable_workfn() init failure path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2936,7 +2936,8 @@ static void scx_set_task_state(struct ta
 		warn = prev_state != SCX_TASK_READY;
 		break;
 	default:
-		warn = true;
+		WARN_ONCE(1, "sched_ext: Invalid task state %d -> %d for %s[%d]",
+			  prev_state, state, p->comm, p->pid);
 		return;
 	}
 


