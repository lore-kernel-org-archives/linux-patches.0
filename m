Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984DA1F4735;
	Tue, 17 Dec 2024 17:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455390; cv=none; b=u7t/VUzsjWKGo+YcjxVDg8N/9j1CWDOKeNfZ19El717aq7Zy7uXmeNGy/DCiLFmN1BzaOZMKJvXrNnang2KG6sNiOqk4zawSOO9k29xHrgOR+U/KpfqZb1SzkeNfjQ1sDYmMHc9WZclqtpoU59eOVJgDkl2Ig7vQhwvlUdouoXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455390; c=relaxed/simple;
	bh=fz1ZH4HQs8Tqr6QSZzKy2bEjgigoVLetit03pGd+vgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGMQiIxZiIW7WH4dk7l0OCeImP2/NvWdYmJznIGjyqbEpWhe+ntyIvZ3CgVf/LsA9tm9V1Y90n4entMW813l4aC27lvU8T31FHOdZNcW0wta/I9aWApL1DMewaS0gKhdMbtrvSsXdZPbhjI96S2kzKVSv3fWdKOQjGsyqPhYKVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqdjhhEY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqdjhhEY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FEEC4CED3;
	Tue, 17 Dec 2024 17:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455390;
	bh=fz1ZH4HQs8Tqr6QSZzKy2bEjgigoVLetit03pGd+vgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqdjhhEY7XArqfWu0APeY6XGoUGsM9zXl28rMVJkTikzHK3sgGkzaNauduMKEO8EO
	 +TeUqWgh9dbOILu9sxNvBxUsDiDuszya+L1Na+TFOftiBxPxf6pPHLCvGo6ZKngz+S
	 FxQHSAcVziZtuf/MfkUHvAUzP+cTWC2Gn9niR1Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH 5.4 07/24] bpf, sockmap: Fix update element with same
Date: Tue, 17 Dec 2024 18:07:05 +0100
Message-ID: <20241217170519.307875750@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
References: <20241217170519.006786596@linuxfoundation.org>
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
@@ -152,6 +152,7 @@ static void sock_map_del_link(struct soc
 				strp_stop = true;
 			list_del(&link->list);
 			sk_psock_free_link(link);
+			break;
 		}
 	}
 	spin_unlock_bh(&psock->link_lock);


