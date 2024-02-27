Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB98145356;
	Tue, 27 Feb 2024 14:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044078; cv=none; b=UM9hJzX9SoCDhYgwqKeT2id1ZXsAw3v/baFMzC1Pm8CocOQ92Y5WQlDpMw7aeuZrWzoc2BR8+Pe09ocoJ/q+GKEXIjtrUHwlPsO3aAMAkFi2fqtJ/CC7d+3NjBYyQQ/LuUytsAcOth1ai/W456gtBeOzdLQGavHxc/af0SohdiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044078; c=relaxed/simple;
	bh=s8OaApCdEFGh7MMABZbmwSGTxRZ/m1kubGcoyHJhWm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2Zv/xQUUQ4Uwk8rrJadgGgTeZxPA4WJGxI3hJg5wotN0qFocjMn/2FEx+V/SLR3WB6BxjkpUCo5p4GObHAp7gabKVgaxy9spxFew2jPBSMFApH2PBI6xPkGQ1fzyRtIiQ5gGMHP41MOiaDJHgpL1Pjl20W/4WeSVKQB9wHDT+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGB36+eS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGB36+eS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9D8C433C7;
	Tue, 27 Feb 2024 14:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044078;
	bh=s8OaApCdEFGh7MMABZbmwSGTxRZ/m1kubGcoyHJhWm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGB36+eS7c8rM70cDLZ4ICpn8jpfjlgm60EsF0ZtfwlJYW/U2mLPor4rgM2kuAp2L
	 HFhvV+1LsYePzZhgSdDEA2oA5qXJYxWqw/2McxVw3/0JZ9/mafwz7vz5dxb3kjVL9Q
	 dntWTziQfZ7xMs/ADt8zjH2yaJQNmkxWmPKPfG8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/122] cifs: add a warning when the in-flight count goes negative
Date: Tue, 27 Feb 2024 14:26:56 +0100
Message-ID: <20240227131600.508814013@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit e4645cc2f1e2d6f268bb8dcfac40997c52432aed ]

We've seen the in-flight count go into negative with some
internal stress testing in Microsoft.

Adding a WARN when this happens, in hope of understanding
why this happens when it happens.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f83901c1c17a5..b2a7238a34221 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -82,6 +82,7 @@ smb2_add_credits(struct TCP_Server_Info *server,
 		*val = 65000; /* Don't get near 64K credits, avoid srv bugs */
 		pr_warn_once("server overflowed SMB3 credits\n");
 	}
+	WARN_ON_ONCE(server->in_flight == 0);
 	server->in_flight--;
 	if (server->in_flight == 0 && (optype & CIFS_OP_MASK) != CIFS_NEG_OP)
 		rc = change_conf(server);
-- 
2.43.0



