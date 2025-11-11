Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1BE1482E8;
	Tue, 11 Nov 2025 01:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822877; cv=none; b=sFNYtN2+p0ChUFFplEXfUB088uJIiRLolOwZ5WlOIqSNU6CRPIbTv9ij4ciyPnOimrC6OcwKzmPrnpQSVRsPRvSNC9ZVWnDXyko2byNPbinqwEFquXkdB5iTWGyPOSaADd9cLMR9Qxw35emnSR+apk0zZDJJ0diO44oUdZEnF/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822877; c=relaxed/simple;
	bh=mI71i+blKKxjdw3Afq5jhh3LpzmWd7uWBmzCSenYacA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/Ml2+dhLZiRRnBGseWiJorRv00z733LlPlyG9wj0+zhV7xHLTkkGiFH0IkIIJVstkXp6RKaI1C/raZg2tMSdgJv23NkNGPsaX+LTLgbHqTmXGGO+4rikl+pevQHcEG6+gk7bVVsJxN4OoHC0GdjvDVquv4AYGsQGLOa5bMoC4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2upEfMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2upEfMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397C1C16AAE;
	Tue, 11 Nov 2025 01:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822877;
	bh=mI71i+blKKxjdw3Afq5jhh3LpzmWd7uWBmzCSenYacA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2upEfMhJY5nK08o7y/loKx6ZC/QNBQUCWu919LalkhdtsWlfVEOOo3a6aLdulrwg
	 nytvDBloH5Et2e6VleCyrmuiuLiQUtOBjKvNMs+QJqBGLcGEbIQ/hAIsxhKG6e01gy
	 Y5R9GTUdchS/fLjBmc11DkpzURKYGi5yQYo69/l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 188/849] io_uring/zcrx: check all niovs filled with dma addresses
Date: Tue, 11 Nov 2025 09:35:58 +0900
Message-ID: <20251111004540.971994978@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit d7ae46b454eb05e3df0d46c2ac9c61416a4d9057 ]

Add a warning if io_populate_area_dma() can't fill in all net_iovs, it
should never happen.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/zcrx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 2035c77a16357..23ffc95caa427 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -75,6 +75,9 @@ static int io_populate_area_dma(struct io_zcrx_ifq *ifq,
 			niov_idx++;
 		}
 	}
+
+	if (WARN_ON_ONCE(niov_idx != area->nia.num_niovs))
+		return -EFAULT;
 	return 0;
 }
 
-- 
2.51.0



