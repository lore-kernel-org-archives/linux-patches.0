Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A4038DC4C;
	Fri,  7 Aug 2026 15:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117667; cv=none; b=TBphg4TWQ1LjQ0DZsFrWFCjsC068UCywdHQjHQkNZgmo5L5p/Z8t/QDJ7hRDXQAxmt5gIwUOJFXLPntMCLDEpO1+l1X7xBc1kSqnkrEp7cc4EmpprV6yayyodfd3i+Gu5No2y1SsNN7wBK8piopZ9olxXm2AT4O/LtEA6w+gGl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117667; c=relaxed/simple;
	bh=xE+nywl5fvThhuLZm+5PDUNb8z/k3nenfu/2VDzAwi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPkN9Z7tNZ5GYZFiOLgp+vZXELeNlzGAtu/h87zoAZDr2PfnWuSL+jvfRVZ4r7h+ED5Kj9kbIzOB2WEeUzxzxS8NeSisBAZlgOyApHu9w0uEqq12ymJd7ytRPnSWn2RzVI/4pS8VJ6ZEzXgbwIZtECcTrDJPYsBDlfjOGV7iFDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ryV4rCSm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryV4rCSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F281F00A3A;
	Fri,  7 Aug 2026 15:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117666;
	bh=GJGdaBmA+JJziNjksmeoEHoeHv2EsXQ1SsoArV3cHJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ryV4rCSmQPi9ty8sLiBE7sv+icHVJEPRipLoKnjd4sGBEVU1CSmXJFJVOSmR6m2KU
	 hX9oQmGEzh6iK6s//FFfWeAv1IMUqIjaJm1mO9ZuFXJNMBk86/bywIaU6fifs7MXQw
	 S1JKzN2OzAitCQdBGJGqh3/a6jKxQNjfPfzPNlxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 397/438] drm/amd/display: check if dml21_add_phantom_plane() is successful
Date: Fri,  7 Aug 2026 16:39:53 +0200
Message-ID: <20260807143436.424300328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 000acb4ce7fb9feba3072ce468ad681f6585cd5d upstream.

Verify that the phantom plane was allocated to avoid a later
segfault.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4970
Fixes: 70839da63605 ("drm/amd/display: Add new DCN401 sources")
Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 5adb54abe5a8e82cbff7f8806db30a5f4924329f)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2_0/dml21/dml21_utils.c |   15 ++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/dml21_utils.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/dml21_utils.c
@@ -359,14 +359,13 @@ void dml21_handle_phantom_streams_planes
 					main_plane = main_stream_status->plane_states[dc_plane_index];
 
 					/* create phantom planes for subvp enabled plane */
-					dml21_add_phantom_plane(dml_ctx,
-							dc,
-							context,
-							phantom_stream,
-							main_plane,
-							&dml_ctx->v21.mode_programming.programming->plane_programming[dml_plane_index]);
-
-					phantoms_added = true;
+					if (dml21_add_phantom_plane(dml_ctx,
+								    dc,
+								    context,
+								    phantom_stream,
+								    main_plane,
+								    &dml_ctx->v21.mode_programming.programming->plane_programming[dml_plane_index]))
+						phantoms_added = true;
 				}
 			}
 		}


