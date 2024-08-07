Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9A527448;
	Wed,  7 Aug 2024 15:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043181; cv=none; b=eim9yHKdxY8DCW2uaKbbM5a08H77I5+9gcg77Jxf/Cf1NEzTczBfOUsS8H1q2Ev7XzIFssit3NWJhjUnCyfUY0++f3us4Xs9nwHy9TMoloav8h2mUq08ofu5UNhoQXk2mzsTZUOwsGp0Az1pF230/ZJ5qtdFKNMhEyiP7H2hUko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043181; c=relaxed/simple;
	bh=dDaGTUse/JAnW/AY1wBqG2xcjIOv/RvT61LjZDUF0Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNycqYB3djY+rCHg+sDohPujbEoVYvYS1Ee8yyjiY6JV+9UD1fkEavn7q18zYssVtGL3tu9ESYODxuyUIfnvgaPpOkUzVkpxQ3stFetvSENEkqON8LNbIJ6rV8oVm53c/G0MBVwoLsE3cwqsMqqHxro3R3VsqMHoqoEWNpgyXMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hb9WWqHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hb9WWqHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96ADC32781;
	Wed,  7 Aug 2024 15:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043181;
	bh=dDaGTUse/JAnW/AY1wBqG2xcjIOv/RvT61LjZDUF0Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hb9WWqHMkGOpjmPyVsQspyaSQPoQDX704t4R4cY+elYdwIaiRhDRCX8uxP7+44AeJ
	 xM49dy8qc2/HfkOljYAyPqaSbcYn8ZgnQbMrOK0jD/2Zkx1mIW0yo2BLCXX02ADytk
	 C3i3hWJ7aQ5KTrqOiH2Lm5jQ7skyOnOnd9LZxFY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jing <liujing@cmss.chinamobile.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.10 121/123] selftests: mptcp: always close inputs FD if opened
Date: Wed,  7 Aug 2024 17:00:40 +0200
Message-ID: <20240807150024.858592654@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


