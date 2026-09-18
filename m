Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7313737B00F;
	Fri, 18 Sep 2026 00:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789692794; cv=none; b=FrTrXSL5P7/wRqldRHPWL+3+y0f8+ttRZWZ/XeSL/fzbWZnbz6ZnEVHiub9K2sRKvxNpndU70NfOj1w1jEdREw6TJ/GZ1nQ3tPMVAtDbH+6ogU4dOFp98uEBet1Ibvws+4nxzXawy6lcZk58p8xgSfXCu8Z/9P0LqdMidYzniyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789692794; c=relaxed/simple;
	bh=GrfSkA2m2anYz34Mp8PFuoeWrkFTlyg7zst/ThdKvkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGhHz2L2Z5m2I/JPXaYRgGp2Y3RmRbQetooRVHduxf3lqs3NFk5Gx3jYRVsV/29iHEvNHXiQQYk9tAwUGprLSb/NUZnpaR4LHerjm2Z+M/CoPETZKCXWzbOPcw3h1Bma4IblTjU5ovI406T2lZED0MDZ1TWGVRLphdGapCgRsJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJmOt6xu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJmOt6xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376521F00898;
	Fri, 18 Sep 2026 00:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789692793;
	bh=EOHTuJ75xi+LQDRNJvaWRluBaC2phIV8uaRcQh0h8XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZJmOt6xupfjfHPUca4ACHJOV5ON+QdGqFn7Gc2GYTarJSyzaQtfa9nOcCmdCCPjw6
	 ae2n/6XI3xqmdmYZI0XvFRDIKPvGiJXtAJa9YOQG76QwIgsvwh15xUES+dBhpVWNlV
	 3fOrCKyB44E6T27KI8RqWVLECTqAPWU3rORqv3WAv+MNMO4MFYJjf+yeGMm7l/10oH
	 /TIvvf2geeQQvV9l7MylGd5FolBSLYnWlqMaMUb+F3/NkLmsdp7KZZaqVoFgu4F6RZ
	 bUPbPJF+9k/d+XTJB2NgbuCfYtqGH+xGxmJivLNBI6QQxLrmWKCgQx9T29zAHZnm93
	 PQMRQNLiLaIsg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	=?utf-8?q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?utf-8?q?G=C3=BCnther_Noack?= <gnoack@google.com>,
	Paul Moore <paul@paul-moore.com>,
	syzbot+bf4903dc7e12b18ebc87@syzkaller.appspotmail.com
Subject: Re: [PATCH 6.1.y] selftests/landlock: Add layout1.refer_mount_root
Date: Thu, 17 Sep 2026 20:52:45 -0400
Message-ID: <2026-09-17-daily-reply-0018-landlock-refer-mount-root-v2@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <661e8a7821258da80d7ab0e2c2d7e19b07ccfae0.1789655724.git.mic@digikod.net>
References: <661e8a7821258da80d7ab0e2c2d7e19b07ccfae0.1789655724.git.mic@digikod.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [ Upstream commit 0055f53aac80fd938bf7cdfad7ad414ca6c0e198 ]
>
> Add tests to check error codes when linking or renaming a mount root
> directory.

The backport places #include <linux/mount.h> before <sys/mount.h>, which breaks
the whole fs_test build on glibc older than 2.36: MS_RDONLY is a macro in the
kernel header and an enumerator in the glibc one. That hits RHEL 8 and 9,
Ubuntu 20.04 and 22.04, and SLES 15. Both the 6.6.y and the
6.1.y copies have it.

Upstream 0055f53aac80 ("selftests/landlock: Add layout1.refer_mount_root") puts
that include last, under the comment "Intentionally included last to work
around header conflict".

Could you respin both patches with the include moved below <unistd.h>, keeping
upstream's comment?

-- 
Thanks,
Sasha
