Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209395;
	b=GzrrWB7TmkaWZL/S81GZYeQQaZqWs9pA01Q9IZqGzgLo8Dwk+N28nfcqkd2aKrqJjmEn
	 1vSdoYXGiTeyrl1lqbPpdpxKvllwBdlOYenjrRXWa6MqJern7NhFtq5Veqo6l5NM0GWCS
	 bM1V6ca+IEEo0lxIVjUca9kXSwlwgSzLX1Q5deWNOxzDiJ0C9+ywQ1lscv0Nqs0YbIKSa
	 fBbyUU82wG7BUgeaNvCXNbuf5tewSZKmb/t5OqcuQx4b3ML9PsljPrxzXtkUJmBXEUQb1
	 WlkrWmey1ifUvrjhocvqLEg5ZPap34sxaT6zDDwtqHbZGu2magpaOeNo7t14jrqxjXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4cPzgGW4eq/lcoxcYWph4PPuoIM5pmzYAtBCszglJqI=;
	b=KIRko06pOAXAO3giaLisOuK7cX9KvjOfu90jXgIhqjeGt2CtzREY0jPbe6GVhiokOwTc
	 RJzQ7fnnDlomk9vzPfoAy252HkBM/3uKk2NfFQVxi5ChBVoErem5ffVRk1oNlSKQ3ugJZ
	 VwkC7/hYeWWxqOpva1fVHnw0B65V6m6Va4i+pCaMsggupuRdQEuu8E7uOlydRLKyDdkrQ
	 sbcB80cbrT4kjzDTysENN40VXSwNv1dT5t5IYERlTEREW10lu+PrP/iF2vFlEmRdOl1MA
	 InGd8uMNDmMi7sUS+D2ux9jbDuGJAcCq8pkwlqpdFGqrbSu6njOAQMv+urL3l+u0ROA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tyge1rMC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59751606A31A;
	Wed, 28 Oct 2026 17:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tyge1rMC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA81E1F01825;
	Wed, 28 Oct 2026 17:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209395;
	bh=4cPzgGW4eq/lcoxcYWph4PPuoIM5pmzYAtBCszglJqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tyge1rMCOV3yCuthEWpHc1i4cbrT8BaMHxJw89RuAHqNhXNOSF+vgMEowmHXn1exs
	 8jhOOlB5ASL0EAGzxps7RydCs5gsJoWa8stu8JA1tyhrIp+melfsZJPtO7qYrlStLY
	 T+sQwpgehoh2BNqsQTohpS0SdI9fbKflPqax856Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 5.10 455/516] tools: gpio: fix building from the top level with O=
Date: Wed, 28 Oct 2026 18:00:07 +0100
Message-ID: <20261028170014.258935363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sashal@kernel.org>

commit 52336337f1a01ad803c7f3ddb23f40222e9ad58d upstream.

"make O=<dir> tools/gpio" fails:

  Makefile:27: /tools/build/Makefile.include: No such file or directory

tools/Makefile clears srctree, and the gpio Makefile only works it out
again when building_out_of_srctree is not set, which the top-level
Makefile sets for O= builds.

Also work out srctree when it is empty, as tools/bpf/Makefile does
since commit a89b2cbf71d64 ("tools, bpf: Fix build for 'make -s
tools/bpf O=<dir>'").

Fixes: 4a6a6f5c4aeed ("tools: gpio: Use !building_out_of_srctree to determine srctree")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261011223358.2327625-5-sashal@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/gpio/Makefile |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/gpio/Makefile
+++ b/tools/gpio/Makefile
@@ -7,7 +7,13 @@ bindir ?= /usr/bin
 # isn't set and when invoked from selftests build, where srctree
 # is set to ".". building_out_of_srctree is undefined for in srctree
 # builds
+ifeq ($(srctree),)
+update_srctree := 1
+endif
 ifndef building_out_of_srctree
+update_srctree := 1
+endif
+ifeq ($(update_srctree),1)
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
 endif


