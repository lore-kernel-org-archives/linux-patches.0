Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0B82DEA74;
	Tue, 21 Jul 2026 18:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659923; cv=none; b=VK4bXLr/biwlFWO3QamXBnNo+6hZ8G7DOBiA+dNEXFQRcVH0reLq+/+HfqTAbD4r9raslY2rQT5+6l9NUnVBWhsgE+qgxgADiTEX/xDOA7IMTMWMOJ97/F7COWYwBlk+GAtyW3Deh0WVt1oUukC/7siJuUFA+dy1bOHU1tdcXDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659923; c=relaxed/simple;
	bh=VCjXnEiPZ1mau4YGkLFed/GQAgWRXOeM7Qo/yxf8p3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/9xJofoAytMHjSdXSHYNADRZcUz4eSSZ3/f6Annpyi6jWkHc/j18ac4MT5IiDroptJx5qUMkfVMoWCFYBMlZpzbHD49RisSVw2HKgP0D2C+8Gjt9TkBmyJtOqbGyEKsQrdpU4FMXJ4d80eIbrOOv84EZLZTYDXFBmzmI6lRBOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4ahYjhN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4ahYjhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0DA1F00A3D;
	Tue, 21 Jul 2026 18:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659921;
	bh=3n1gZsz+gqRAFZXNJ8n0DD4g8+5MGdpDmef1jTT2I58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4ahYjhNylHBEuOQID8+Hh2sb2vki6tLQF3EZ6fAqjwwdI0N4cJ2n6kshT/rGMFnr
	 qZzqJP8kG5RZt9C4WO0j6Q0jdNk4mpxhtOlP4Q8Og/A8WRV5ZbFIY0d5j4Ql9ZwCUb
	 YMToLR8Ng3YVrSWwN4vqwbv8KlQvu1Fy5gOSjB98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0740/2077] handshake: Require admin permission for DONE command
Date: Tue, 21 Jul 2026 17:06:53 +0200
Message-ID: <20260721152610.249458985@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 81246a65303d9635266b1334490142caaf86a11f ]

ACCEPT and DONE are the two downcalls of the handshake genl
family, both intended for use by the trusted handshake agent
(tlshd). ACCEPT already requires GENL_ADMIN_PERM; DONE has
no privilege check at all.

The fd-lookup in handshake_nl_done_doit() only confirms that
some pending handshake request exists for the supplied sockfd;
it does not authenticate the sender. An unprivileged process
that guesses or observes a valid sockfd can therefore submit
a DONE with HANDSHAKE_A_DONE_STATUS == 0, leaving the kernel
consumer to proceed as if the handshake succeeded. A non-zero
status on a forged DONE tears down a legitimate in-flight
handshake before tlshd can report its real result.

Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://patch.msgid.link/20260609141831.90694-1-cel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/handshake.yaml | 1 +
 net/handshake/genl.c                       | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/handshake.yaml b/Documentation/netlink/specs/handshake.yaml
index 1024297b38513a..ffec12b467597d 100644
--- a/Documentation/netlink/specs/handshake.yaml
+++ b/Documentation/netlink/specs/handshake.yaml
@@ -125,6 +125,7 @@ operations:
       name: done
       doc: Handler reports handshake completion
       attribute-set: done
+      flags: [admin-perm]
       do:
         request:
           attributes:
diff --git a/net/handshake/genl.c b/net/handshake/genl.c
index 4b20cd9cdd0e09..feac1ad063ee72 100644
--- a/net/handshake/genl.c
+++ b/net/handshake/genl.c
@@ -38,7 +38,7 @@ static const struct genl_split_ops handshake_nl_ops[] = {
 		.doit		= handshake_nl_done_doit,
 		.policy		= handshake_done_nl_policy,
 		.maxattr	= HANDSHAKE_A_DONE_REMOTE_AUTH,
-		.flags		= GENL_CMD_CAP_DO,
+		.flags		= GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
 	},
 };
 
-- 
2.53.0



