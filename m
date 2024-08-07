Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B5284A40;
	Wed,  7 Aug 2024 15:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043769; cv=none; b=oT0aLKhofdO6XboYNZYOIqqxcWY2LieCxFD5hlwGZTTgl5ojDBoT2umytjk1lOM78G+r/xUSF6loH721N4kNtrIZ+10pPYQSKg8dsxZl2aSUuca/rqEeUjx1g8pgM1DuLv4keefX3V2Q2La/yF1Gy7KAIsm5fp5Tfneu8sLGJq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043769; c=relaxed/simple;
	bh=PKvbZotSyvJWE6Qm7rAo/EFehEmeIjcDAVFIzCPIPjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/qphDbts6M/N365APKoxh4moPPFspZMl2iTkSeqs7h9YIIQbZ4n2lyVJXL//ejx50NnvDP8euUZOxuONeY5zGYUeQytDY5TYnaKKz/OimYA3rSX4sPPQqCZqIzl806lb1d1T2+4FT47gU34rNnyJAosKePflOUtLVYq27xyCNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohHZY4p/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohHZY4p/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C781EC32781;
	Wed,  7 Aug 2024 15:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043769;
	bh=PKvbZotSyvJWE6Qm7rAo/EFehEmeIjcDAVFIzCPIPjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohHZY4p/CZI/8tA4nqPVUxQqsVcDUCjtd8HxEu18FjnSalbpILP0buPJWAlFLWBva
	 w7aQMqotJNmcCxgO8JMOvNoEGs9DdigTQ7vtXnxjC8Uz/9ri1ibpb1txiw9wzjimPJ
	 OnjynkraOJXvIYTgNEbUCkbxM3MTr6kZFpUIZY7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jing <liujing@cmss.chinamobile.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 86/86] selftests: mptcp: always close inputs FD if opened
Date: Wed,  7 Aug 2024 17:01:05 +0200
Message-ID: <20240807150042.129045376@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

From: Liu Jing <liujing@cmss.chinamobile.com>

commit 7c70bcc2a84cf925f655ea1ac4b8088062b144a3 upstream.

In main_loop_s function, when the open(cfg_input, O_RDONLY) function is
run, the last fd is not closed if the "--cfg_repeat > 0" branch is not
taken.

Fixes: 05be5e273c84 ("selftests: mptcp: add disconnect tests")
Cc: stable@vger.kernel.org
Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -1040,11 +1040,11 @@ again:
 		return 1;
 	}
 
-	if (--cfg_repeat > 0) {
-		if (cfg_input)
-			close(fd);
+	if (cfg_input)
+		close(fd);
+
+	if (--cfg_repeat > 0)
 		goto again;
-	}
 
 	return 0;
 }


