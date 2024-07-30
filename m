Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BEE1A6162;
	Tue, 30 Jul 2024 16:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356638; cv=none; b=LW1SFE/V1UheMdf6Y0xGmamnC+T+RG5aKIGAx1zSo3iYVzyysDo8BEMdAVCJSRKwuXJe0zQliBGNrxQXT18jgHOMhfBS9b2VFbYy0U0cG46HrTMW/WRmhXRR6AgvuF9W3+Psi9cJL7ZBo/iSrnSS9A0a85fK8/Bs7qdPzsExWqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356638; c=relaxed/simple;
	bh=u9MjgaEGOI2GJsRbhKF2YXGVDJjkQ/MAw2ogNW7K4Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcJ3WWVupwgV5yqtW8FaRv0y5jH95Cp0FN0NVuxpUHh6PQC4NLErxwgXwmSrT/xdKbob8ffc3QR9fEPMkLWkZVNFC4H6h6ibPvP98M6YWfopNG04mbke3sujtMHKvaAcYd3hMlWVsYZYJnF0ipmIqUgAdon9vVHYwP9KE7DWhZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/a551DP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/a551DP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4E6C32782;
	Tue, 30 Jul 2024 16:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356638;
	bh=u9MjgaEGOI2GJsRbhKF2YXGVDJjkQ/MAw2ogNW7K4Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/a551DPkXKyPXBZ9yQZ656SqXIfLBm90bHCeZJoJ9ZJmAxWjpnCYHbgHhuP7sC91
	 nXE4uJSujhFmzTH9gomEBU3i+fQX9LdIJOgJzIQ3QnE5NMEjaDmvDzu6QHlurxRV5L
	 yIS/e3KX9EuZLvqW8Y23AkshOSIXQjj7UaZ9wzBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Cohen <amcohen@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/568] selftests: forwarding: devlink_lib: Wait for udev events after reloading
Date: Tue, 30 Jul 2024 17:44:36 +0200
Message-ID: <20240730151646.491585485@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f1de525cfa55b..62a05bca1e825 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -122,6 +122,8 @@ devlink_reload()
 	still_pending=$(devlink resource show "$DEVLINK_DEV" | \
 			grep -c "size_new")
 	check_err $still_pending "Failed reload - There are still unset sizes"
+
+	udevadm settle
 }
 
 declare -A DEVLINK_ORIG
-- 
2.43.0



