Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898A730FC33;
	Thu, 16 Jul 2026 14:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211507; cv=none; b=Zs4LZaXJCg2q0FgYAYLQirokv6LqQQVcu/yG/eK0ORVNC706Tu3MFBYhEzget2CS4vMh8qrKm8/dlZzx+WsHyKMXCPEd2TX+msD4zAGVkfjhzoTPr+23Tp5zBKLrRrBduOc4axEgayGNAb2xF01yDi7BCJ7lfPQw5F8s8qmEfz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211507; c=relaxed/simple;
	bh=q9zqjhGtXLT9SVSbhGnCMejjl1RocOriCr7cE3LJzBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSa3zCRLph0y7u1X27/IK3lr9bGxzmP2HnsHmSs2cyuwPQEH0Q08RPTeDPyA7y2P92idEYFrtDbwqkd+wKxYQFgvU88yPYNZX9lqavXO31k9297G7rbBfAYgGgtpvkYdN9bt6lBVtpy/5CJRY7Hd9+Etn+iZj/x1UpzCM43tXC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzFwV2pE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzFwV2pE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DA41F000E9;
	Thu, 16 Jul 2026 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211506;
	bh=AOTNJyS8r4tUC0vw7Xotv90tWiyjLKzRakiS1rfYctE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gzFwV2pE04BfM9eaIjItEUw7Rpj+3wDXSpIZVom3TQjJznd6MXW4VrX7qbKfcXlQp
	 IIIjvTvQjD6D9GNH2wkPueYUAQhn+XWcC6C1aVrRvq7KVBCG2ZiZgbikbGZLpQieLs
	 5bAE7rGVhIRaaGqSzUCFzQh5niTHYRlKEiBbpyPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 453/480] Input: gscps2 - advance receive buffer write index
Date: Thu, 16 Jul 2026 15:33:20 +0200
Message-ID: <20260716133054.621411520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit d86d4f8cbb5a55a3b9b86f7b5ab8c4cdda600a3f upstream.

Commit 44f920069911 ("Input: gscps2 - use guard notation when
acquiring spinlock") moved the receive loop into gscps2_read_data()
and gscps2_report_data().

While moving the code, it preserved the writes to
buffer[ps2port->append], but omitted the following producer index
update from the original loop:

	ps2port->append = (ps2port->append + 1) & BUFFER_SIZE;

As a result, append never advances. Since gscps2_report_data() only
reports bytes while act != append, the receive buffer always appears
empty and no keyboard or mouse data reaches the serio core.

Restore the omitted index update.

Fixes: 44f920069911 ("Input: gscps2 - use guard notation when acquiring spinlock")
Cc: stable@vger.kernel.org # 6.13+
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/460B5655BA580C60+20260624094739.850306-1-raoxu@uniontech.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/gscps2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/serio/gscps2.c
+++ b/drivers/input/serio/gscps2.c
@@ -219,6 +219,7 @@ static void gscps2_read_data(struct gscp
 		ps2port->buffer[ps2port->append].str = status;
 		ps2port->buffer[ps2port->append].data =
 				gscps2_readb_input(ps2port->addr);
+		ps2port->append = (ps2port->append + 1) & BUFFER_SIZE;
 	} while (true);
 }
 


