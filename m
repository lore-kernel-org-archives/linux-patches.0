Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CB5269820;
	Tue,  8 Apr 2025 11:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111722; cv=none; b=SlSqQAcWHBxGC8uokYV1CsIdEKg0GDur89iszjiuGPN/LKQtruCfd9lZfwwocgJuaUtkpLWBk8U34NNSh8Z9i0eQpI3dr0NG8fzSiSk3ErykP3NejofK4NltBKQNJCkg37rTnznfENUcMmfbX2GTAR8AXLbdBV9M7CnXETpO5QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111722; c=relaxed/simple;
	bh=xBXsYSzshCz1e+dKkA3wsnckDA439cz5sD7qGsCrg04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ez0a7qJ4hFgcWU2LolcSFdEcNDMNcNObecHl0FN+9LFSHE2mP0La+RKXrfMR/RbbP4u7Y8qZNrxbAtFIjzBCiSW61fTqFHNAiGDwG3W7/4sZYbMxFNG/Ss0xds/ikNwZNs7g0iP8doo2RXwfpCGe5GlDf/JBjwqcbGghRUBPWQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GcphmkiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GcphmkiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859E3C4CEE5;
	Tue,  8 Apr 2025 11:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111721;
	bh=xBXsYSzshCz1e+dKkA3wsnckDA439cz5sD7qGsCrg04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GcphmkiH2WAVY5Q+hwBOvm/uJjIXWU4GEgGgp0i0y2sqw7kmP9cuef4ABj9Vf6KC1
	 hGa1yBjganQNXvuBvlWkVAqd9puqCdHhDQUM3hU/XyMz15SNQT2IyCVXAJOk8xo68/
	 MPQUQH76ahyahxgo8JIA0sOUyoG9W4lKRLJ9sniM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 535/731] staging: vchiq_arm: Fix possible NPR of keep-alive thread
Date: Tue,  8 Apr 2025 12:47:12 +0200
Message-ID: <20250408104926.721259024@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 3db89bc6d973e2bcaa852f6409c98c228f39a926 ]

In case vchiq_platform_conn_state_changed() is never called or fails before
driver removal, ka_thread won't be a valid pointer to a task_struct. So
do the necessary checks before calling kthread_stop to avoid a crash.

Fixes: 863a756aaf49 ("staging: vc04_services: vchiq_core: Stop kthreads on vchiq module unload")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20250309125014.37166-3-wahrenst@gmx.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index e2e80e90b555b..d3b7d1227d7d6 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -1422,7 +1422,8 @@ static void vchiq_remove(struct platform_device *pdev)
 	kthread_stop(mgmt->state.slot_handler_thread);
 
 	arm_state = vchiq_platform_get_arm_state(&mgmt->state);
-	kthread_stop(arm_state->ka_thread);
+	if (!IS_ERR_OR_NULL(arm_state->ka_thread))
+		kthread_stop(arm_state->ka_thread);
 }
 
 static struct platform_driver vchiq_driver = {
-- 
2.39.5



