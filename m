Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071F6472767;
	Tue, 16 Jun 2026 17:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629361; cv=none; b=TLpY9V8pwiNeg089SbcAStK7OwFOgT7QtQeUH0q6dWaXSvviQjifxF7a/YE8XW0cprgDJKt9G6R+3KnC/hc97qk/y/+DZPYcOds4BlK2zxdmL/cTYcNsqW5195sW6uk7oU4HNGN6PvGhxNusq4e+gg0U6jxV0hm1l/rTwxF8r6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629361; c=relaxed/simple;
	bh=XUt3KUx6xY8sZYyN7qDH8LObvW7Ka/gAN3UKG33Vh1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdxAIItjJ+eeNr6fvZgRXRb1e2Yi5ibFnWHRkr1KsCFpi2k1oXKIEyBYsM5Iv9XGUAYHaYsYoQTZZfzEsRv6DzfYFna7EchM2XsGig9ooiD3Jy84wDSXuDfV3UeggZv8XStJRr7qvjF0PFsrS/uuvVTkUB8rhth7Ejjw1Trlz18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XO/nodHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XO/nodHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148921F000E9;
	Tue, 16 Jun 2026 17:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629360;
	bh=L/jeg9LYXI0KE4W760SHvH7hOhdtkM2/mevdEbpNRQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XO/nodHDUNrZ56oZvMmDiUFTlV5aqKOwbiS/UmIp3VNNK+M/XD9kqmAlkEZlWfcY3
	 rrv6sIseyg+CZkhFXh+ja6Xr0zwHdvlNNwouInUoetOerto98NAxdfjYpuJHxWdrz3
	 L2Mz3eMMxrhfv9cHGudsm4FBh5UOKQMN/gIWpDBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 253/452] tools/rv: Fix cleanup after failed trace setup
Date: Tue, 16 Jun 2026 20:28:00 +0530
Message-ID: <20260616145130.942358719@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit 33ec2269a4155cad7e9e42c92327dcaa9aee59a7 ]

Currently if ikm_setup_trace_instance() fails, the tool returns without
any cleanup, if rv was called with both -t and -r, this means the
reactor is not going to be cleared.

Jump to the cleanup label to restore the reactor if necessary.

Fixes: 6d60f89691fc9 ("tools/rv: Add in-kernel monitor interface")
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/r/20260514152055.229162-5-gmonaco@redhat.com
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/verification/rv/src/in_kernel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/verification/rv/src/in_kernel.c b/tools/verification/rv/src/in_kernel.c
index ced72950cb1eed..64ae847313f6dc 100644
--- a/tools/verification/rv/src/in_kernel.c
+++ b/tools/verification/rv/src/in_kernel.c
@@ -655,7 +655,7 @@ int ikm_run_monitor(char *monitor_name, int argc, char **argv)
 	if (config_trace) {
 		inst = ikm_setup_trace_instance(monitor_name);
 		if (!inst)
-			return -1;
+			goto out_free_instance;
 	}
 
 	retval = ikm_enable(monitor_name);
-- 
2.53.0



