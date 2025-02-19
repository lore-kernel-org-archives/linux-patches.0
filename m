Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2811CD213;
	Wed, 19 Feb 2025 09:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957038; cv=none; b=PXno4TDS1TVm55br+WnVjUJd0apv5tw7H+BuczA8w2D6+f4tIKTunP2+exQb7Zc12n/IiII+bjRamzNZoVS2I3IZm167dofJOvdrrU7BSPYtMIKBnqXXDjzaddefP8dEQfEuKnfST5IywfOSGEvrhyj55jLZY/bnyiuRq1ciNLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957038; c=relaxed/simple;
	bh=ALuItMa+7gqdvyclOQf1XwIcodKHLUCcXahLkmS6B0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OolLlt4hARPogbFna4Gb3xjCmec9b5Xtsits6+gjcYp4RpTZZfL2o26K+qsvHe1cIWneIxUCZtNwZIKgUN/4H5qbd/5oBPNL5qDegJSHjXkScHIZZbitWIzncNgTZdw0e3CDUpZbx6OJaQ90MYULoiqO7XzMBaBMIYIJJonM5xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RwXMLR8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RwXMLR8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D848BC4CED1;
	Wed, 19 Feb 2025 09:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957038;
	bh=ALuItMa+7gqdvyclOQf1XwIcodKHLUCcXahLkmS6B0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwXMLR8Cw3nnLV7JydnXYkmZKebr6bsYxOYta3TJMHXum7eAa5fAGrG7RzOnZFjWj
	 DlUAYt7JFI8qj3eUgAo2kxfNLqBSVZUsYEk326C/rTAw80YyWny3iNFFpDnXDfK8VH
	 BzIvLkqbUzO6XxVDTdIjjhAU4erdkhxzkWaapqZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 355/578] Bluetooth: L2CAP: accept zero as a special value for MTU auto-selection
Date: Wed, 19 Feb 2025 09:25:59 +0100
Message-ID: <20250219082706.987697207@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 5c61419e02033eaf01733d66e2fcd4044808f482 upstream.

One of the possible ways to enable the input MTU auto-selection for L2CAP
connections is supposed to be through passing a special "0" value for it
as a socket option. Commit [1] added one of those into avdtp. However, it
simply wouldn't work because the kernel still treats the specified value
as invalid and denies the setting attempt. Recorded BlueZ logs include the
following:

  bluetoothd[496]: profiles/audio/avdtp.c:l2cap_connect() setsockopt(L2CAP_OPTIONS): Invalid argument (22)

[1]: https://github.com/bluez/bluez/commit/ae5be371a9f53fed33d2b34748a95a5498fd4b77

Found by Linux Verification Center (linuxtesting.org).

Fixes: 4b6e228e297b ("Bluetooth: Auto tune if input MTU is set to 0")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -728,12 +728,12 @@ static bool l2cap_valid_mtu(struct l2cap
 {
 	switch (chan->scid) {
 	case L2CAP_CID_ATT:
-		if (mtu < L2CAP_LE_MIN_MTU)
+		if (mtu && mtu < L2CAP_LE_MIN_MTU)
 			return false;
 		break;
 
 	default:
-		if (mtu < L2CAP_DEFAULT_MIN_MTU)
+		if (mtu && mtu < L2CAP_DEFAULT_MIN_MTU)
 			return false;
 	}
 


