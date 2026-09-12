Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D7128B517;
	Sat, 12 Sep 2026 08:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200386; cv=none; b=MPpT1i5Uhm1a3kqefWW2B6hvy2dd0qy7Wsp0ukusHOgEZueKde5rGDiiy/xr1dReu9wgnJ8QNRpX7T2nvSs0fWjLaks6aqWIONnAj6a+njn6DUapMDjLldigd91K/ViW2Q8kJz/MPntDmzgfixPdhR38gkeEf9MpA9Q0eSUKF/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200386; c=relaxed/simple;
	bh=2R70K/QWqu6wRDF+9SokOThcaJOy52DLbq0WhbojUWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGw7JQ3c3DS8Etum+2BblcYYUHJ9L17UunyRwjHKe29O2zm5WYbfb0WGQFSz3eO8MKT10I4Fqb49ujwfARQASCrISKCctZws6yC3ULUvsFjTcwx8fcCvb5tv+dBo/+1rauXRNyZ8frAMu5V3CEFtXk/S25zQozGt+GfhRE9+2xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mj3bg5Sc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mj3bg5Sc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D78E1F000FF;
	Sat, 12 Sep 2026 08:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200384;
	bh=mm07kJfkkYMFtHA5svyYA+Q6hQO4OhuMLRmWJo2Q6qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mj3bg5ScwoRo5PjBozaG50vXwNHMKP/0GYncrX/eomg9uPBZirDO+cZZKKQlKD0f8
	 GQB9CkMI//4oJvWTMWeddfTzNYC5OX0eOY4S2bM0iGLHmTDIxt317FBFSl6IcmVqWn
	 RIOpPUk1XT0FgDlc09omDDLmZW4N/Lw07+ngmlkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0736/1815] media: staging/ipu7: fix async notifier leak on init error
Date: Sat, 12 Sep 2026 08:41:26 +0200
Message-ID: <20260912065706.180734235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit 11ccf31a657f9f95260a22848b7d324d3c6cf113 ]

isys_notifier_init() initialises a v4l2 async notifier and then, for
each CSI-2 port, adds a remote sensor subdev to the notifier's
waiting_list via v4l2_async_nf_add_fwnode_remote(), which allocates a
sensor_async_sd descriptor and takes a fwnode reference.

If parsing or adding a later port fails, the code jumps to the
"err_parse" label, which only drops the current endpoint fwnode
reference and returns, without calling v4l2_async_nf_cleanup(). Any
descriptors already added to the notifier for earlier ports are
therefore leaked, and the caller's error path does not clean up the
notifier either.

Call v4l2_async_nf_cleanup() on the error path, matching the cleanup
already performed when v4l2_async_nf_register() fails. This is safe as
the notifier is always initialised before the loop is entered.

Fixes: a516d36bdc3d ("media: staging/ipu7: add IPU7 input system device driver")
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu7/ipu7-isys.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/ipu7/ipu7-isys.c b/drivers/staging/media/ipu7/ipu7-isys.c
index bf262c01a2b80..601e5a79ef8ec 100644
--- a/drivers/staging/media/ipu7/ipu7-isys.c
+++ b/drivers/staging/media/ipu7/ipu7-isys.c
@@ -233,6 +233,7 @@ static int isys_notifier_init(struct ipu7_isys *isys)
 
 err_parse:
 		fwnode_handle_put(ep);
+		v4l2_async_nf_cleanup(&isys->notifier);
 		return ret;
 	}
 
-- 
2.53.0



