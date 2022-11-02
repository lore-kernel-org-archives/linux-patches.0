Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9534629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB520C433C1;
	Wed,  2 Nov 2022 03:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359374;
	bh=2rghsGQG0u7hvM3ksqrLWfuLRkoTS4/T1LGEmXIRwQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+YPquvn6YJ2kKI9UMU5vPxbFRT3dC1J0Qq3tVNzIwcD4BAv1S06xGE54sjzkRPe9
	 BCVzSQUN5ns9z7clM229O4wI2CeOuPiBfJ/sfxbK+PFHwwLBi47XQr+DrM4Gvhi2w7
	 gCKJU+Vy9MuZ0Q0g+OxeLJ31pBZxoQYo2mJ2oMyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhou <chenzhou10@huawei.com>,
	Zefan Li <lizefan.x@bytedance.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Luiz Capitulino <luizcap@amazon.com>
Subject: [PATCH 5.4 28/64] cgroup-v1: add disabled controller check in cgroup1_parse_param()
Date: Wed,  2 Nov 2022 03:33:54 +0100
Message-Id: <20221102022052.730247943@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Zhou <chenzhou10@huawei.com>

commit 61e960b07b637f0295308ad91268501d744c21b5 upstream.

When mounting a cgroup hierarchy with disabled controller in cgroup v1,
all available controllers will be attached.
For example, boot with cgroup_no_v1=cpu or cgroup_disable=cpu, and then
mount with "mount -t cgroup -ocpu cpu /sys/fs/cgroup/cpu", then all
enabled controllers will be attached except cpu.

Fix this by adding disabled controller check in cgroup1_parse_param().
If the specified controller is disabled, just return error with information
"Disabled controller xx" rather than attaching all the other enabled
controllers.

Fixes: f5dfb5315d34 ("cgroup: take options parsing into ->parse_monolithic()")
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
Reviewed-by: Zefan Li <lizefan.x@bytedance.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luiz Capitulino <luizcap@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup-v1.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -944,6 +944,9 @@ int cgroup1_parse_param(struct fs_contex
 		for_each_subsys(ss, i) {
 			if (strcmp(param->key, ss->legacy_name))
 				continue;
+			if (!cgroup_ssid_enabled(i) || cgroup1_ssid_disabled(i))
+				return invalf(fc, "Disabled controller '%s'",
+					       param->key);
 			ctx->subsys_mask |= (1 << i);
 			return 0;
 		}


