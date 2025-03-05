Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CD214884C;
	Wed,  5 Mar 2025 18:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198622; cv=none; b=MpP8HRnNitW27o7hMivDLvjj14U40Zh8fLOCgQxsUvIbgB3JOiFgRlOGHhWQPKWLEc8uVolKNFOm8nYDj+hL7Xy1NK702io+MpqUWxHulIukdDVLnouepH3+iJG5xFAtsbydvUKUvlQeLzB4i2TuGofczOtQnTgaM6y0aAo7R8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198622; c=relaxed/simple;
	bh=Otk++TUzDuLMDd2A6fNwUHXAFaKZU7L4WNwCgh6jTh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQBQNzUZi7+vlqw6biypr/QQ1EJHrTgrwyMzNqWCBpmu2AwJYizxeBkPJKBPB9nxnyEN4wUYGLrBLDvH70PYzzIRUC6GNvEJcW1kw0h8zqyoYP4ubXug5QAX0/mpguznzH0AcPBdrGZLeMVr0dPvMfqAF+aMMGL/Cu58Hb7nOck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQjZ1BhT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQjZ1BhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0090C4CED1;
	Wed,  5 Mar 2025 18:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198622;
	bh=Otk++TUzDuLMDd2A6fNwUHXAFaKZU7L4WNwCgh6jTh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQjZ1BhTF2JbV+8jWvu9ZTZzkqp8uTc1OGyfLv6/vJefHBVBiWkHB2ZOwnvXQLWgI
	 RWjtmPUsVBKHDP1B231+xh/whE42OuUDkLJMd9UwZbdWVg4QxuRmr/r3GF1tNNLj/o
	 lUCEJUhNRdURdQemvlkBAGyOy78afh7hWVnAW0Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	David Wei <dw@davidwei.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 060/157] selftests: drv-net: Check if combined-count exists
Date: Wed,  5 Mar 2025 18:48:16 +0100
Message-ID: <20250305174507.717766446@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

From: Joe Damato <jdamato@fastly.com>

[ Upstream commit 1cbddbddee68d17feb6467fc556c144777af91ef ]

Some drivers, like tg3, do not set combined-count:

$ ethtool -l enp4s0f1
Channel parameters for enp4s0f1:
Pre-set maximums:
RX:		4
TX:		4
Other:		n/a
Combined:	n/a
Current hardware settings:
RX:		4
TX:		1
Other:		n/a
Combined:	n/a

In the case where combined-count is not set, the ethtool netlink code
in the kernel elides the value and the code in the test:

  netnl.channels_get(...)

With a tg3 device, the returned dictionary looks like:

{'header': {'dev-index': 3, 'dev-name': 'enp4s0f1'},
 'rx-max': 4,
 'rx-count': 4,
 'tx-max': 4,
 'tx-count': 1}

Note that the key 'combined-count' is missing. As a result of this
missing key the test raises an exception:

 # Exception|     if channels['combined-count'] == 0:
 # Exception|        ~~~~~~~~^^^^^^^^^^^^^^^^^^
 # Exception| KeyError: 'combined-count'

Change the test to check if 'combined-count' is a key in the dictionary
first and if not assume that this means the driver has separate RX and
TX queues.

With this change, the test now passes successfully on tg3 and mlx5
(which does have a 'combined-count').

Fixes: 1cf270424218 ("net: selftest: add test for netdev netlink queue-get API")
Signed-off-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: David Wei <dw@davidwei.uk>
Link: https://patch.msgid.link/20250226181957.212189-1-jdamato@fastly.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/queues.py | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/queues.py b/tools/testing/selftests/drivers/net/queues.py
index 38303da957ee5..8a518905a9f9c 100755
--- a/tools/testing/selftests/drivers/net/queues.py
+++ b/tools/testing/selftests/drivers/net/queues.py
@@ -45,10 +45,9 @@ def addremove_queues(cfg, nl) -> None:
 
     netnl = EthtoolFamily()
     channels = netnl.channels_get({'header': {'dev-index': cfg.ifindex}})
-    if channels['combined-count'] == 0:
-        rx_type = 'rx'
-    else:
-        rx_type = 'combined'
+    rx_type = 'rx'
+    if channels.get('combined-count', 0) > 0:
+            rx_type = 'combined'
 
     expected = curr_queues - 1
     cmd(f"ethtool -L {cfg.dev['ifname']} {rx_type} {expected}", timeout=10)
-- 
2.39.5



