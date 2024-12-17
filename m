Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C151F8903;
	Tue, 17 Dec 2024 17:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455850; cv=none; b=p98rZ2aPxbzptAkbn7bvgtH654mdAfPl6kCsZ0n/6m2tH4MohB/LUYmxE9arOxs8MZiekH8BaJmjr5FTJuBzhsND9tROpeQetK09tlv4W03GRDQpQ1gKZ9nRDCcFGr6BiEB21TjUeWnk/pVa44OPMScFwOJYe0S3bP5hH/rYcSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455850; c=relaxed/simple;
	bh=j5T5DHnwUjuNSQY0OxS0xu173u57+jYrntXQC+3mHq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDBWgF9E8GM0rZ+t7wWJSpnihZwZ/YjCXUreVmR7e8qwADlKPsds76EpSnfO95O7qQiVm1TgG0fITSXByTdX0sTjHJA0ZdjattlXuqAQ5fAM2+v8KUV8kSNDz0ppo8lA56LhsYj4C8cf4McKenAOSnmT6kZrrPyLdu8bPq+Zt4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1KOTNUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1KOTNUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB680C4CEDD;
	Tue, 17 Dec 2024 17:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455850;
	bh=j5T5DHnwUjuNSQY0OxS0xu173u57+jYrntXQC+3mHq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1KOTNUPiV6vXjeqMG0PY6UsFj9MB7pE3hfFr/kpAF84NNyaI1yZnDD3qraEmwW73
	 tqqRmmY/yWZRpUngJTEdHHCZvLyxCUBn7aCbxiIUrHvrSKjYF82cJjC9fclFe07kmM
	 C0PWYNfYfaA4ETnkgrvZpFaNDjr646WCpjA6xRS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 6.1 23/76] bpf, sockmap: Fix update element with same
Date: Tue, 17 Dec 2024 18:07:03 +0100
Message-ID: <20241217170527.220668771@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

commit 75e072a390da9a22e7ae4a4e8434dfca5da499fb upstream.

Consider a sockmap entry being updated with the same socket:

	osk = stab->sks[idx];
	sock_map_add_link(psock, link, map, &stab->sks[idx]);
	stab->sks[idx] = sk;
	if (osk)
		sock_map_unref(osk, &stab->sks[idx]);

Due to sock_map_unref(), which invokes sock_map_del_link(), all the
psock's links for stab->sks[idx] are torn:

	list_for_each_entry_safe(link, tmp, &psock->link, list) {
		if (link->link_raw == link_raw) {
			...
			list_del(&link->list);
			sk_psock_free_link(link);
		}
	}

And that includes the new link sock_map_add_link() added just before
the unref.

This results in a sockmap holding a socket, but without the respective
link. This in turn means that close(sock) won't trigger the cleanup,
i.e. a closed socket will not be automatically removed from the sockmap.

Stop tearing the links when a matching link_raw is found.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20241202-sockmap-replace-v1-1-1e88579e7bd5@rbox.co
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock_map.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -158,6 +158,7 @@ static void sock_map_del_link(struct soc
 				verdict_stop = true;
 			list_del(&link->list);
 			sk_psock_free_link(link);
+			break;
 		}
 	}
 	spin_unlock_bh(&psock->link_lock);


