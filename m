Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B3B46A5FB;
	Tue, 21 Jul 2026 15:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649008; cv=none; b=AEa+F3Dz5+M8DIMucSWyopRJ05a2l3aznLwqdF74eECbGnoQjTD3k/6Vc29tkiSo0QYTz0tnn3hzpZfGS2YpdX4OVUctbHOaMRLpHqQxc1XIaHdj/w6Pj40OTlT5Zc3J6dLkAKOr0Ipauy3mJ+RLHmAWGq39T+z1T5LVzWrM2iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649008; c=relaxed/simple;
	bh=unLsZmDdah33fXxyDRjoLIAy9wGpD9QtIbH0eB/ARBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmZ6HS09PBmh95zj7sJWAGlHQQqWdUeHRokaZam08OGiMesNACx5vcIO5JY/I/NvqD9hGmh94vFLrNUNq4YonZwjpSfZ0GwzXlWFHxPhy8BUkxcr3mHcmrM5Js5g3xa4dgTKjHnS1qyJCkD/0Cy7dHYXnLdidKsy75of1AhiWv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VU62Kim0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VU62Kim0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E231F1F000E9;
	Tue, 21 Jul 2026 15:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649007;
	bh=WDwOJpnG5GyLYtfcHJcrDBEZvDUuAyM4Ry8TRpRkDdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VU62Kim0nuaG2Trqh0oQAd+EiK/Ecd+8TDY+xdbmFeK6qDjbFZpxaCKF4NJiSRWrD
	 YFo5xGlZ10jlV1qz+nmtsosKYdbrdBZmwE6DlSOkxJvjdmAE2j6hicCQ14imJMibpc
	 CPQqfpbYerGfTjitdcO9hYbMJcM2yrrN7KySB9rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Pratyush Yadav (Google)" <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0408/2077] liveupdate: fix TOCTOU race in luo_session_retrieve()
Date: Tue, 21 Jul 2026 17:01:21 +0200
Message-ID: <20260721152602.355043253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pasha Tatashin <pasha.tatashin@soleen.com>

[ Upstream commit d3ae9e7fddb4036f50003d7fa1ef52801fdb961b ]

Extend the scope of the rwsem_read lock in luo_session_retrieve() to
overlap with the acquisition of the session mutex. This prevents a
concurrent thread from releasing and freeing the session between the
lookup and the mutex lock.

Fixes: 0153094d03df ("liveupdate: luo_session: add sessions support")
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://patch.msgid.link/20260527202737.1345192-3-pasha.tatashin@soleen.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/liveupdate/luo_session.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index ec7aebc15a8016..85af0963d66ae0 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -419,12 +419,11 @@ int luo_session_retrieve(const char *name, struct file **filep)
 	struct luo_session *it;
 	int err;
 
-	scoped_guard(rwsem_read, &sh->rwsem) {
-		list_for_each_entry(it, &sh->list, list) {
-			if (!strncmp(it->name, name, sizeof(it->name))) {
-				session = it;
-				break;
-			}
+	guard(rwsem_read)(&sh->rwsem);
+	list_for_each_entry(it, &sh->list, list) {
+		if (!strncmp(it->name, name, sizeof(it->name))) {
+			session = it;
+			break;
 		}
 	}
 
-- 
2.53.0



