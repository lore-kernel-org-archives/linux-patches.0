Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADFA365A0B;
	Sat, 12 Sep 2026 09:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204015; cv=none; b=TN48cywZjUoogad7KCR79mdP2tdxRqqi2T/c0e19rf/PBD6zieTIh8ZjcOpDBTXyhA/hEhCmEva+ctCVB/ZIXZ6AkTKYAhHwioF72039ERwGye+yasJMH/Oz8YzCgY5Vf7huBm5mR2Ucbm923IIJ7FketAQSKnEmyL7owzT2a5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204015; c=relaxed/simple;
	bh=wgDBr//Y/9K67rqkPG+Jf7q1fgv4a+/XCgbd6yLdfyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snWgbiI4h8/4mdNBpe4MDhUBXfGfDYD43399AKcRiX7UIRXilEpN47RRUeJCKjwzKuzUCI2bUydNcMG4IEjTrnFzQd+DDtRCL1734weewOeHMO5ro7hHWgyFow/UdwdTgMKHHZBUvmHH/JPJXV/smgWBJfor+YKiKadRwiOxv4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pJKK/+Lm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pJKK/+Lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE6D1F000FF;
	Sat, 12 Sep 2026 09:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204014;
	bh=heqZYB5ROuGXpQ5BOlIsViaoEOS+RDBqnHNWJATVDYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pJKK/+Lm6YCgl1V5coBtV/1fHOdkNktbu0/iScVjc92WjLlTcyXuYYeytTrlNmUtT
	 gUOEdGcdKZpNSzK5EuSc22HiWrCBs1qeTSlkUT5OQTtWqV0xMfF5ejjnvk86OdaPOv
	 HicGKmfvRuFbtS18RL7lkst9TxO2t7b21iZsp500=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1509/1815] ksmbd: fix durable handle v2 default timeout units (60 -> 60000)
Date: Sat, 12 Sep 2026 08:54:19 +0200
Message-ID: <20260912065724.422329129@linuxfoundation.org>
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

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit c1d7bbfc5e081875053723d1a69eb2cf341eaaf1 ]

When a client's Durable Handle Request V2 sets Timeout=0 ("let the
server choose"), fp->durable_timeout was set to 60. Every other use
of this field is in milliseconds: DURABLE_HANDLE_MAX_TIMEOUT (300000)
in smb2pdu.h, the nonzero branch immediately above
(min_t(unsigned int, dh_info.timeout, DURABLE_HANDLE_MAX_TIMEOUT),
where dh_info.timeout is the wire value and already milliseconds per
spec), and the scavenger in vfs_cache.c, which adds it directly to
jiffies_to_msecs(jiffies).

60 is off by 1000x: the handle becomes scavenger-eligible 60
milliseconds after close instead of 60 seconds. A client requesting
Timeout=0 is relying entirely on the server's default to cover the
gap between a dropped connection and its reconnect -- 60ms is not
enough time for even a fast network blip to be detected and
reconnected, so any real disruption loses the race and a subsequent
DH2C reconnect fails with a durable-handle lookup miss instead of
succeeding.

Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: b0148dc5625d ("ksmbd: serialize oplock close with pending break ownership")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8ef3123655c57..c01c72ea00d2a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4019,10 +4019,17 @@ int smb2_open(struct ksmbd_work *work)
 					min_t(unsigned int, dh_info.timeout,
 					      DURABLE_HANDLE_MAX_TIMEOUT);
 			else
-				fp->durable_timeout = 60;
+				fp->durable_timeout = 60000;
 		}
 	}
 
+	/*
+	 * conn->is_aapl detection above (this function's create-context
+	 * parsing) is skipped on the reconnect path below, since a
+	 * reconnect always arrives on a fresh connection -- if the client
+	 * cares, it sends its own AAPL context on this same CREATE, which
+	 * this function's normal (non-reconnect) parsing already handles.
+	 */
 reconnected_fp:
 	rsp->StructureSize = cpu_to_le16(89);
 	opinfo = opinfo_get(fp);
-- 
2.53.0



