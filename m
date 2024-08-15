Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C061AC432;
	Thu, 15 Aug 2024 14:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731186; cv=none; b=PeGNAUU29oxPESFaqODJwbn9nYeBWodWQ1huyWxEwI6j5ijV4BEkbBeL5dhvwvCkEz+RKFM2+Ml3wgv64PCLwbdd2iBUyka4NZEZldzkeyv4OMn+Eq1kPUk+9DFujmazb98PqbyuFZS/VPBC51EN2Swvzr6VsI2AhCurPOZyOn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731186; c=relaxed/simple;
	bh=LhS83TKx5iyV6evjA1hhLMCoaYqy4PWIYmoxXqNURH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDieLXI4l682pwonmuExW93TkJ9YBnEP/rLFdi0aXtyhFBANNHLXXo8yNS5+cM0B+GRAHMXyQ3EepHXQx8j89kFqE8dOWL7JVQMCp21v+2nk2hhZIq+uT9QA+kzhxYGYoc26HmYX1UqZTDFxBx6f/aukDePrisG5Qn+n+38lMEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZA3AQC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZA3AQC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAA2C32786;
	Thu, 15 Aug 2024 14:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731186;
	bh=LhS83TKx5iyV6evjA1hhLMCoaYqy4PWIYmoxXqNURH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rZA3AQC4Tai9glyztCUIdkYP8MPLwzXFtvrxfgiJpB9s8zP6ST3eI1RjSdAaifXVX
	 wz+s/etujWuk9s+vq9/2lvyL6F++J2ccKycPGv5PcPh+cK7ue1jIJuM4VMsH3ZvOap
	 p9hKDH5bEeQ/UFaNlZCZSo9PAuXm9qyqvIbg5U74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Cohen <amcohen@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/259] selftests: forwarding: devlink_lib: Wait for udev events after reloading
Date: Thu, 15 Aug 2024 15:23:02 +0200
Message-ID: <20240815131904.698384432@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 13d03a6d85ba9..dd9a856318588 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -102,6 +102,8 @@ devlink_reload()
 	still_pending=$(devlink resource show "$DEVLINK_DEV" | \
 			grep -c "size_new")
 	check_err $still_pending "Failed reload - There are still unset sizes"
+
+	udevadm settle
 }
 
 declare -A DEVLINK_ORIG
-- 
2.43.0



