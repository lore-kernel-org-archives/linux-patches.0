Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB57C24DFF9;
	Mon,  1 Dec 2025 11:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588581; cv=none; b=Q3KZ7PfabED5tux/keEgbn2CXTiLU/ghYCKoQg6pct5WqUOwbR7iyzEamy+OcPZXx+r4nxK7KDKBd3aCs1jgLc55/d84xjFuNE0obmEYErF6MTr+E7OGs2uPtlSGWagoIzqSzJ9Ksc7c/kqfeFMO1h9FqOrYcKMq0sKh8mfjjCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588581; c=relaxed/simple;
	bh=seoH5z4Pt93faqElTgzafYIHSFHmjLRxXMJISaFcYjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGHZUoWpkt4hRJ5KnJ/rkb5jzfUbgerQmCWMufwlxS544XsW+2UDdOosogOQIrEuSvNWV2Vmjvww8it+XXRAymUCM/4gbSWEWfKXdBbqWTZ+lAqRB22GF3MWD8MXyeF52HGKkI5rytB6iifitsEy8OlLLKQn2gtxKo42cOWDH4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ps99gTVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ps99gTVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797E3C4CEF1;
	Mon,  1 Dec 2025 11:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588580;
	bh=seoH5z4Pt93faqElTgzafYIHSFHmjLRxXMJISaFcYjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ps99gTVwvKCb2UHR3YXezUdgVWzZJxdaR+91VsR1ouR9MCbyDFjuGdmF/xJC3A4ER
	 pvQ0+xwRkHh4p/L0eb4NGuiqOkbZ2f79vOVsPpatP6vLlK2i6d0HIG6u5640YJ7f4S
	 nU4e3t6qdBc/1EnbN+AoTe33PpBym51LSTySUWoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Iliopoulos <ailiop@suse.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 099/187] NFSv4.1: fix mount hang after CREATE_SESSION failure
Date: Mon,  1 Dec 2025 12:23:27 +0100
Message-ID: <20251201112244.816238392@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Iliopoulos <ailiop@suse.com>

[ Upstream commit bf75ad096820fee5da40e671ebb32de725a1c417 ]

When client initialization goes through server trunking discovery, it
schedules the state manager and then sleeps waiting for nfs_client
initialization completion.

The state manager can fail during state recovery, and specifically in
lease establishment as nfs41_init_clientid() will bail out in case of
errors returned from nfs4_proc_create_session(), without ever marking
the client ready. The session creation can fail for a variety of reasons
e.g. during backchannel parameter negotiation, with status -EINVAL.

The error status will propagate all the way to the nfs4_state_manager
but the client status will not be marked, and thus the mount process
will remain blocked waiting.

Fix it by adding -EINVAL error handling to nfs4_state_manager().

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index b64a3751c3e4a..49defb02cc201 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2660,6 +2660,9 @@ static void nfs4_state_manager(struct nfs_client *clp)
 	case -ENETUNREACH:
 		nfs_mark_client_ready(clp, -EIO);
 		break;
+	case -EINVAL:
+		nfs_mark_client_ready(clp, status);
+		break;
 	default:
 		ssleep(1);
 		break;
-- 
2.51.0



