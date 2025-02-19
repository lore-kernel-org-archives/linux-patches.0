Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9605A1DE2B7;
	Wed, 19 Feb 2025 08:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954026; cv=none; b=n7mzvt3ngxEbUc1+SL+bJLSXZQWTumsURguRscsPg+CokgEXXg4G9MesIKDpZPsAajFLKLxfLgvo8aXbCbNqJoaO9ry8OwWmTh4hPnnbUDCQ7jbGwiZpY+e27sgigu6vnNiFWOeXCJ+SPeCAeSkgUjH5EEV5CduMxeaZ7f3y88I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954026; c=relaxed/simple;
	bh=t/w7xoVMxLyc4JbFzRZGHlA9QF6KQGT0lnzTQsT2afw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paa/K3Q8ssZrVzycrW7Aoi8epdWWURLXkBqqzmX57pOPtARcoEpoBTbk/3VoyUrjCP8L5aG3q5+DebxUXhcFZTmhFLXIH6rlxkVQ7XEhZx5yxP2XGRiBl2T2w1axvKAdwPUaYS7/aerHhfo6TXgM4KT0EGe3PCBs+NGF+QJciKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFRnzi0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFRnzi0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F30C4CEE6;
	Wed, 19 Feb 2025 08:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954026;
	bh=t/w7xoVMxLyc4JbFzRZGHlA9QF6KQGT0lnzTQsT2afw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFRnzi0MGqJOB4Bmfw2CAirWjKU/Jwj4gaWp3Iw+HxLYLUSN0gxm2BO/xLQfXZ+MI
	 Wb0SDm8CGkOw1SUUYPQXotbfOMwWtMqTfyiYdGO/snI4iYwM/5AklN2bCrv9aLCUWp
	 Jp6ycv8xrFzvPaADk527JtUmliJmvsxDUPkIgNe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@gmail.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 040/274] drm/tests: hdmi: Fix WW_MUTEX_SLOWPATH failures
Date: Wed, 19 Feb 2025 09:24:54 +0100
Message-ID: <20250219082611.095066364@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit fb97bc2e47f694f79d6358d981ae0428db8e8088 ]

The light_up_connector helper function in the HDMI infrastructure unit
tests uses drm_atomic_set_crtc_for_connector(), but fails when it
returns an error.

This function can return EDEADLK though if the sequence needs to be
restarted, and WW_MUTEX_SLOWPATH is meant to test that we handle it
properly.

Let's handle EDEADLK and restart the sequence in our tests as well.

Fixes: eb66d34d793e ("drm/tests: Add output bpc tests")
Reported-by: Dave Airlie <airlied@gmail.com>
Closes: https://lore.kernel.org/r/CAPM=9tzJ4-ERDxvuwrCyUPY0=+P44orhp1kLWVGL7MCfpQjMEQ@mail.gmail.com/
Link: https://lore.kernel.org/r/20241031091558.2435850-1-mripard@kernel.org
Reviewed-by: Simona Vetter <simona.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20250129-test-kunit-v2-1-fe59c43805d5@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c b/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
index 4ba869e0e794c..cbd9584af3299 100644
--- a/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
+++ b/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
@@ -70,10 +70,17 @@ static int light_up_connector(struct kunit *test,
 	state = drm_kunit_helper_atomic_state_alloc(test, drm, ctx);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, state);
 
+retry:
 	conn_state = drm_atomic_get_connector_state(state, connector);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, conn_state);
 
 	ret = drm_atomic_set_crtc_for_connector(conn_state, crtc);
+	if (ret == -EDEADLK) {
+		drm_atomic_state_clear(state);
+		ret = drm_modeset_backoff(ctx);
+		if (!ret)
+			goto retry;
+	}
 	KUNIT_EXPECT_EQ(test, ret, 0);
 
 	crtc_state = drm_atomic_get_crtc_state(state, crtc);
-- 
2.39.5



