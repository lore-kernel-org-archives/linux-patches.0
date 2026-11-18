Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050968;
	b=GsLgZu3fqyBOTBxb5UqllQiWerCjHklfjzB3wJolbZeg/rW42HrtZ87DI5uIBor4IGxq
	 VJxPejJsrizjbT0c12IZAxzZF4LBdqX3O1WjmjZc7ucLjquxtFxf01VmPmiVl96zU0CV4
	 7a5ylxJgX4zQWYvrKveZ8lzv5c1wa0oQLLF9DDQkGFbXhU3afhKa5MSFtuJzJ2yCMV4pW
	 +xUSMzqQaP10Be4o1eRJbs1RUvhGwoPlwvl5YyDI2M0VvQuiIHO+JGSMWCXebB+1BO5Of
	 GwuCN2g4rnDlhNUZfb8Oq1q4Bx6EcIqsEJ1RjA4/sSLIclCx+Hga2H9YBh9k9bGr0mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ghSyl/eLEw065e1dkyggxwOrkPu1ec8lSm2aYYgzzpQ=;
	b=WwP8QkGHtHrQbyV1CKjffrxJlRzosKcZbNztWP8qphSA+AkHVk82OYiFfni/ZET6pjpy
	 x7mqgjGGdUibQuzEFbQPvZHIktZUjeY99SvLjHTF/C9J+G8vvw0hGc9GM7GCnz1cdLCGj
	 WMGdRkBJyLKUI4LqlFiBJSZLCnQKzEsuC5Y8FbzEUM2xUJMm7HCmfONJOealUUMxSCq5U
	 wfvd72z+28EAgjgUoRiJ839SkvC5Wacw4yFadyjy1cpCvM6vZTlIEYnbBWinePrdki4mZ
	 slYg1/J3+m5CXEYYdYCGJqF0Bz8E60Y1Rwd5sHmYTBCc7H5akyl1m6ed8GXrNYOkKEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vslT4nPj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D22F606A325;
	Thu, 19 Nov 2026 01:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vslT4nPj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D60C1F000C4;
	Thu, 19 Nov 2026 01:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050968;
	bh=ghSyl/eLEw065e1dkyggxwOrkPu1ec8lSm2aYYgzzpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vslT4nPjDiGNB8L91UHJTM0c+tF+4KLaTnrppA/iELCDlwVEJBip28gG5scD7lyey
	 CsbcAqtX8P90xjrP4wB3KVA7ehaW7o3LHE6uMOKZc0dvquOfcu1PwPyAqJb28lD/ji
	 aU5VAh3W9ZguAUPyn396ZogJ9Iz8Edp9vHohR5Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juanlu Herrero <juanlu@fastmail.com>,
	Anand Natarajan <anand@meta.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0010/2214] io_uring/poll: avoid retry wakeup loss when dropping ownership
Date: Wed, 18 Nov 2026 15:28:06 +0100
Message-ID: <20261118150010.564401810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juanlu Herrero <juanlu@fastmail.com>

[ Upstream commit 937d38dcacd675dc0572d6c9b6743960df3128ed ]

If a wakeup sets IO_POLL_RETRY_FLAG between the owning task consuming
the existing instance of IO_POLL_RETRY_FLAG and the loop check
of io_poll_check_events(), then we stall on processing the request
until an unrelated wakeup comes along.

Using atomic_cmpxchg instead of atomic_sub_return to guarantee both the
count v and poll_refs are 0 and no wake-ups are missed.

Cc: stable@vger.kernel.org
Fixes: a26a35e9019f ("io_uring: make poll refs more robust")
Signed-off-by: Juanlu Herrero <juanlu@fastmail.com>
Assisted-by: LLM
Suggested-by: Anand Natarajan <anand@meta.com>
Link: https://patch.msgid.link/20261013-pu-cmpxchg-v1-1-4ddc10fd8a03@fastmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ sashal: Relocated the change to io_poll_check_events() in the monolithic io_uring implementation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8d5791d8f4031..a87b24c77c0ee 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5690,8 +5690,8 @@ static int io_poll_check_events(struct io_kiocb *req)
 		 * Release all references, retry if someone tried to restart
 		 * task_work while we were executing it.
 		 */
-	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs) &
-					IO_POLL_REF_MASK);
+		v &= IO_POLL_REF_MASK;
+	} while (atomic_cmpxchg(&req->poll_refs, v, 0) != v);
 
 	return 1;
 }
-- 
2.53.0



