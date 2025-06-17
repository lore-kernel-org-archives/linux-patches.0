Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099C62EA143;
	Tue, 17 Jun 2025 15:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175472; cv=none; b=iF0X5Lzslnbq9OyfbHGQmAqV+/W065H55dYSwR8LMlZEQUoX3A/0JlowZHgoJQ/Cp0KzQg/MbXOLvrV2lJMKOKeyo3Lpkj2aY2RvqhqToGI50hend2gC6DCmbJj7DLTJdGjXHlCXTaLV5IfUkucxxqda/RaVN4N+X/vm0PyMDx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175472; c=relaxed/simple;
	bh=YvrvUYEBYaUw5u/Ev1tweaRTEfqkbvHuGaoANjpxQqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfNFu7u1ssVJUUfTvo1B0I1IN9ZxtMiy/MgrUIdBysv9niUauIhz/uqvXPiPXxQnGblNbV4NXZBoRo9WfkmD5GU1BxQXGnUPfDvfQ9Z5hwKhlZptaRcIT1VcZjdeDG++zJjrRWVzcAzIJIhU7aBDm7o72GceOv1fCDeMxJEj+B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TASV4xwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TASV4xwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCEEC4CEE3;
	Tue, 17 Jun 2025 15:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175471;
	bh=YvrvUYEBYaUw5u/Ev1tweaRTEfqkbvHuGaoANjpxQqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TASV4xwPe+Acpctriwz9ULebGTmqPq/E0v5bMUfSE/r6Aj548aaZHbi03977aA2YO
	 Ga5YJUMgZ4BhwMp469ymfY7aCh7X3Li7J7nVRQFKW7WJ32KNoddOop7zONzG4M4Ayc
	 5S8KUB929Iaa5Zc21JyAzAAX+sbM8T/Ry2YGi4lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Raman <vignesh.raman@collabora.com>,
	Daniel Stone <daniels@collabora.com>,
	Helen Koike <helen.fornazier@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 091/780] drm/ci: fix merge request rules
Date: Tue, 17 Jun 2025 17:16:39 +0200
Message-ID: <20250617152455.222206705@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vignesh Raman <vignesh.raman@collabora.com>

[ Upstream commit 10646ddac2917b31c985ceff0e4982c42a9c924b ]

Merge request pipelines were only created when changes
were made to drivers/gpu/drm/ci/, causing MRs that
didn't touch this path to break. Fix MR pipeline rules
to trigger jobs for all changes.

Run jobs automatically for marge-bot and scheduled
pipelines, but in all other cases run manually. Also
remove CI_PROJECT_NAMESPACE checks specific to mesa.

Fixes: df54f04f2020 ("drm/ci: update gitlab rules")
Signed-off-by: Vignesh Raman <vignesh.raman@collabora.com>
Reviewed-by: Daniel Stone <daniels@collabora.com>
Signed-off-by: Helen Koike <helen.fornazier@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250228132620.556079-1-vignesh.raman@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ci/gitlab-ci.yml | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/ci/gitlab-ci.yml b/drivers/gpu/drm/ci/gitlab-ci.yml
index f04aabe8327c6..b06b9e7d3d09b 100644
--- a/drivers/gpu/drm/ci/gitlab-ci.yml
+++ b/drivers/gpu/drm/ci/gitlab-ci.yml
@@ -143,11 +143,11 @@ stages:
     # Pre-merge pipeline
     - if: &is-pre-merge $CI_PIPELINE_SOURCE == "merge_request_event"
     # Push to a branch on a fork
-    - if: &is-fork-push $CI_PROJECT_NAMESPACE != "mesa" && $CI_PIPELINE_SOURCE == "push"
+    - if: &is-fork-push $CI_PIPELINE_SOURCE == "push"
     # nightly pipeline
     - if: &is-scheduled-pipeline $CI_PIPELINE_SOURCE == "schedule"
     # pipeline for direct pushes that bypassed the CI
-    - if: &is-direct-push $CI_PROJECT_NAMESPACE == "mesa" && $CI_PIPELINE_SOURCE == "push" && $GITLAB_USER_LOGIN != "marge-bot"
+    - if: &is-direct-push $CI_PIPELINE_SOURCE == "push" && $GITLAB_USER_LOGIN != "marge-bot"
 
 
 # Rules applied to every job in the pipeline
@@ -170,26 +170,15 @@ stages:
     - !reference [.disable-farm-mr-rules, rules]
     # Never run immediately after merging, as we just ran everything
     - !reference [.never-post-merge-rules, rules]
-    # Build everything in merge pipelines, if any files affecting the pipeline
-    # were changed
+    # Build everything in merge pipelines
     - if: *is-merge-attempt
-      changes: &all_paths
-      - drivers/gpu/drm/ci/**/*
       when: on_success
     # Same as above, but for pre-merge pipelines
     - if: *is-pre-merge
-      changes:
-        *all_paths
       when: manual
-    # Skip everything for pre-merge and merge pipelines which don't change
-    # anything in the build
-    - if: *is-merge-attempt
-      when: never
-    - if: *is-pre-merge
-      when: never
     # Build everything after someone bypassed the CI
     - if: *is-direct-push
-      when: on_success
+      when: manual
     # Build everything in scheduled pipelines
     - if: *is-scheduled-pipeline
       when: on_success
-- 
2.39.5



