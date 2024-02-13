Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65908604AB;
	Tue, 13 Feb 2024 17:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845634; cv=none; b=cPXhZO/PIGPOSUZpQUz5bCfOWzkmgjvCInT7skaEIopoO5HJKjUfGmH26zMxxFj8B2BUalhjcF/uAl+pTy6KZ8TND9wFrBdq+KeEi4sAsyS2ZEKINrI+oPOa2YejN7/9VTTHJgwzlSf7JTDVHpiVKJj7/Q2bskMySBMLMJjY8XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845634; c=relaxed/simple;
	bh=6+o/bc7tL0/dZTEp5Kh5yKFIcvXlY2o+tsEerln5J34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVHCwL5DXDufW3y4Jtta+oTW7zyeo2T0EJyrW92Nm8vaSood5TFOC3FG6xquAfURom4b2WUwbuSUlR3RGdDyvYaf9DPUYWTPt3FMGlXc5e0j7rj1cOvP4r1NzMjmdiLmLFse8AcNuN/Dz80mfSlm8RZGT3MEG4e6++1NdFExX1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vN2UIJMD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vN2UIJMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2A5C433F1;
	Tue, 13 Feb 2024 17:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845634;
	bh=6+o/bc7tL0/dZTEp5Kh5yKFIcvXlY2o+tsEerln5J34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vN2UIJMDVA7iT9vKFPCJaKPXfWmwMi0Cg3tNiMz83CYrzmz42WKOCQDAoHnd3PHai
	 oQhoNkuQHez1VoACU9U4IqwlKxoTqqfqTGuRfR+ZxsonujCrhWn3WID7eZSlCavq9d
	 Rt0y/1eyjbc2oAO9cZkAr9i49/t74tPAWY3p6224=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 015/124] cifs: failure to add channel on iface should bump up weight
Date: Tue, 13 Feb 2024 18:20:37 +0100
Message-ID: <20240213171854.179418063@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 6aac002bcfd554aff6d3ebb55e1660d078d70ab0 ]

After the interface selection policy change to do a weighted
round robin, each iface maintains a weight_fulfilled. When the
weight_fulfilled reaches the total weight for the iface, we know
that the weights can be reset and ifaces can be allocated from
scratch again.

During channel allocation failures on a particular channel,
weight_fulfilled is not incremented. If a few interfaces are
inactive, we could end up in a situation where the active
interfaces are all allocated for the total_weight, and inactive
ones are all that remain. This can cause a situation where
no more channels can be allocated further.

This change fixes it by increasing weight_fulfilled, even when
channel allocation failure happens. This could mean that if
there are temporary failures in channel allocation, the iface
weights may not strictly be adhered to. But that's still okay.

Fixes: a6d8fb54a515 ("cifs: distribute channels across interfaces based on speed")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index a16e175731eb..a1b973456471 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -269,6 +269,8 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
 					 &iface->sockaddr,
 					 rc);
 				kref_put(&iface->refcount, release_iface);
+				/* failure to add chan should increase weight */
+				iface->weight_fulfilled++;
 				continue;
 			}
 
-- 
2.43.0



