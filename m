Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801CF374CC;
	Wed,  7 Aug 2024 15:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043535; cv=none; b=B4NyURB5N14kktZfLjIramcJhgIUgvG5x+xdGiS05nGMIxyXuk8K69jtpkrint/nXW6Zzs+fJls03E/0x/GKYQ241qMxY/xgCixm13yqCUIAzAfzCNS8a0J7EXEdgYD7EWWChZCm9yUV9mg2mvTVDkp5J1esXH48ftJh4nYLKjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043535; c=relaxed/simple;
	bh=n471YNAvsZZZz0Kay9mHMYt/rgXEYyFYrPug7oGcjW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aeli7YzbAQ+MKXPlT4NUhc+cwSI7G/qsN/sQlK3X2CGalE03uLsSnNlaD6xNatc1igYYN6aRlZA9pgL+326ATkA+UT0/SFS7Y+slOJgFOI3MGo88Nm1Ny29d1X6Ve4QOPE3HjN8WAlWgUNvgiD9c9QU05yNc+ilaHw0IVg4rmVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nc0/6Buz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nc0/6Buz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B13C32781;
	Wed,  7 Aug 2024 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043535;
	bh=n471YNAvsZZZz0Kay9mHMYt/rgXEYyFYrPug7oGcjW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nc0/6BuzLBR4a09KeOuHV/csQQo4DuXm5d3TN3Yf4NpADDHucAkah0elkA3J/6BWA
	 B7fkO/Z+DcWlOmqJSrZ1QLqukMJx48KzcgY4L/BGZirsAz2l7RC6cExi75zfBe4frD
	 TeqrRj8PqI0AtyuCVgztC3pqIBVdHD9QExvBCIk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jing <liujing@cmss.chinamobile.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 118/121] selftests: mptcp: always close inputs FD if opened
Date: Wed,  7 Aug 2024 17:00:50 +0200
Message-ID: <20240807150023.261941213@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1115,11 +1115,11 @@ again:
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


