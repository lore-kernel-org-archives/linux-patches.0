Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83A17DA6C;
	Thu, 15 Aug 2024 14:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732065; cv=none; b=hoD166P8y1iOaN4hF6rzmIe1KCKC5x34neFpbDhYlk6cIVXpajwn31Cy5lhmpklokVjhCFmY7Pr5892goP02DOrCSeVIXN8w0cXSSIKXUvF11dkuIw7UbULhtDG+1XWQ4BQddypkgkC5cMpdokbGGujtw+DI/Kt/5iOsBfgsZAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732065; c=relaxed/simple;
	bh=o/dQE6uWZeX6edn2BjtBVy7yTgMvL/KT286LolW6uss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muy6P5uIod+d71Q8ocRwUEyLLNUWn0ajgb1UuMSCPXX0sQFvHJ5wB5OjYj4jds24EfYojRV2bGUNxHNtx82TkmvilOsefxFENvtbY0YvpmomkL2LSCW5sZXjgxAcfNkZCG8ETdEM60xOM6J4uVFHUa01o+yFCqmo2jLBnpIBZ/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r43sf3LV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r43sf3LV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714F8C32786;
	Thu, 15 Aug 2024 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732064;
	bh=o/dQE6uWZeX6edn2BjtBVy7yTgMvL/KT286LolW6uss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r43sf3LV7EpEdfdgAP+HNjumPXginm8IDFHr/r/PVNZOQLBq9iZ9gbiITkdZIlLi6
	 Fbq6AilQ1RbtJALmnjW0eQBjmSJsueuL6ue9YR0OjOdN1rBWKl1zK473NBW5U+6mkZ
	 tSLaY+QnG8EbkMyzVY+cTMrwz3jXCsi6FHMdtZbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Cohen <amcohen@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/352] selftests: forwarding: devlink_lib: Wait for udev events after reloading
Date: Thu, 15 Aug 2024 15:22:10 +0200
Message-ID: <20240815131921.716608793@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit f67a90a0c8f5b3d0acc18f10650d90fec44775f9 ]

Lately, an additional locking was added by commit c0a40097f0bc
("drivers: core: synchronize really_probe() and dev_uevent()"). The
locking protects dev_uevent() calling. This function is used to send
messages from the kernel to user space. Uevent messages notify user space
about changes in device states, such as when a device is added, removed,
or changed. These messages are used by udev (or other similar user-space
tools) to apply device-specific rules.

After reloading devlink instance, udev events should be processed. This
locking causes a short delay of udev events handling.

One example for useful udev rule is renaming ports. 'forwading.config'
can be configured to use names after udev rules are applied. Some tests run
devlink_reload() and immediately use the updated names. This worked before
the above mentioned commit was pushed, but now the delay of uevent messages
causes that devlink_reload() returns before udev events are handled and
tests fail.

Adjust devlink_reload() to not assume that udev events are already
processed when devlink reload is done, instead, wait for udev events to
ensure they are processed before returning from the function.

Without this patch:
TESTS='rif_mac_profile' ./resource_scale.sh
TEST: 'rif_mac_profile' 4                                           [ OK ]
sysctl: cannot stat /proc/sys/net/ipv6/conf/swp1/disable_ipv6: No such file or directory
sysctl: cannot stat /proc/sys/net/ipv6/conf/swp1/disable_ipv6: No such file or directory
sysctl: cannot stat /proc/sys/net/ipv6/conf/swp2/disable_ipv6: No such file or directory
sysctl: cannot stat /proc/sys/net/ipv6/conf/swp2/disable_ipv6: No such file or directory
Cannot find device "swp1"
Cannot find device "swp2"
TEST: setup_wait_dev (: Interface swp1 does not come up.) [FAIL]

With this patch:
$ TESTS='rif_mac_profile' ./resource_scale.sh
TEST: 'rif_mac_profile' 4                                           [ OK ]
TEST: 'rif_mac_profile' overflow 5                                  [ OK ]

This is relevant not only for this test.

Fixes: bc7cbb1e9f4c ("selftests: forwarding: Add devlink_lib.sh")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/89367666e04b38a8993027f1526801ca327ab96a.1720709333.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/devlink_lib.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 9c12c4fd3afc9..6edfd207e3240 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -113,6 +113,8 @@ devlink_reload()
 	still_pending=$(devlink resource show "$DEVLINK_DEV" | \
 			grep -c "size_new")
 	check_err $still_pending "Failed reload - There are still unset sizes"
+
+	udevadm settle
 }
 
 declare -A DEVLINK_ORIG
-- 
2.43.0



