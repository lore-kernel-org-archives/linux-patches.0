Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E7E1448C8;
	Thu, 11 Apr 2024 10:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832263; cv=none; b=uOKLaYcpgQQt/KBRyea4OPPXHpoPcKAOWWO7r6hmeHvHPfHK9q50Mo9gUCTcOHklZ80cs1E3x/kataqK6EvEq8OYW7H1oB2gIvcdX7TY8nDU4YbueNAKE1W+7XNZflC8mmMEtY10gWIeTSX04rVh1fARKyIOyGlZY997YAw8Fvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832263; c=relaxed/simple;
	bh=u0f9ebeITdy06x4Zuhkz+0+td2eWCK7SWbR0Hdunr3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rkyeFWQ/6KPrZDO8ABzY1s4Z3tPiSlFBqaf6V7cWa0hm3nq0+j53yvLQj9AR9Ha8kEmzjc7f3Rm+skoe8jQb4Pt+btztZnN4SM2+jhw5T97a1pRIzaqBKH/HUCl2e0Pc1b6PAvKJMAnY4BC00F2EbVdHFWfhgf4cuQUj4S5RU9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5dVdW/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5dVdW/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBB7C433C7;
	Thu, 11 Apr 2024 10:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832263;
	bh=u0f9ebeITdy06x4Zuhkz+0+td2eWCK7SWbR0Hdunr3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5dVdW/YSveiU7CKBtXxyF6Ys4VgZYHUf+6+nf3zSrSMwe3U6HECY+swdxWuo8647
	 FAFvAYBPQjdb5WZUoydmsqA7UNSYcxIqScVjHru8P5zt0MAoZcJw+qsKsH0CzaN62J
	 SIxWU9flmVUId4JFzGNCcwuJISUli36cUYUH3kFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.10 285/294] tty: n_gsm: require CAP_NET_ADMIN to attach N_GSM0710 ldisc
Date: Thu, 11 Apr 2024 11:57:28 +0200
Message-ID: <20240411095444.114518210@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit 67c37756898a5a6b2941a13ae7260c89b54e0d88 upstream.

Any unprivileged user can attach N_GSM0710 ldisc, but it requires
CAP_NET_ADMIN to create a GSM network anyway.

Require initial namespace CAP_NET_ADMIN to do that.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Link: https://lore.kernel.org/r/20230731185942.279611-1-cascardo@canonical.com
From: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2661,6 +2661,9 @@ static int gsmld_open(struct tty_struct
 {
 	struct gsm_mux *gsm;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
 	if (tty->ops->write == NULL)
 		return -EINVAL;
 


