Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA242206A5;
	Thu, 12 Dec 2024 17:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023251; cv=none; b=JCz4l3wZNrLS1N8AyuuFvBd96Pfe7yqFrI3cIjxM3ya0q2xGsBcLXTJemvFfHkMh8k4iFnc5YMjz9utlLGc0/9KTt2CtxBtzOsxBLwTvOj4vaboXrfn82260M0ZrnG0qb+QXOYYIZeVqgGWwQAyvLI80QYRa896Gj/1vCE/cAgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023251; c=relaxed/simple;
	bh=YO9aKpUY+7UgJrzO2MWfTFK3LOeYBaUyudaxqI31F9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJURfPdin59TxnfhEMdCFVKAX8M1uc5dFBgbsshEc85Ps5Ry3+VbR04KyO+8cQrFLP3CO5ya2/S2XWABUBvPF0ofoYqAbGl3aKU3lcCU7SWAxKingl6oyjENLwZ09Bld1F8viTwlQ5fjfFe+ro6qyXw2Q14twabTjvXw+0QmwAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HldebdBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HldebdBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042FEC4CECE;
	Thu, 12 Dec 2024 17:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023250;
	bh=YO9aKpUY+7UgJrzO2MWfTFK3LOeYBaUyudaxqI31F9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HldebdBLWHo1DjPm11gdsX4hiWX+cbsqZxZjOC/qW73UTETRTwf6Vzpy/mxrXiTEC
	 4Zqcr0iybte4JD5cz188ugDswKetYFQcmiddCv7oLqSD/CLl0LBuOItE/E2WKCWWIM
	 BZmYjiBGM9Nbos6GmDS5IPzecf0Qdruo0JsYI2Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 472/565] kselftest/arm64: Dont leak pipe fds in pac.exec_sign_all()
Date: Thu, 12 Dec 2024 16:01:07 +0100
Message-ID: <20241212144330.402834107@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 27141b690547da5650a420f26ec369ba142a9ebb ]

The PAC exec_sign_all() test spawns some child processes, creating pipes
to be stdin and stdout for the child. It cleans up most of the file
descriptors that are created as part of this but neglects to clean up the
parent end of the child stdin and stdout. Add the missing close() calls.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20241111-arm64-pac-test-collisions-v1-1-171875f37e44@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/pauth/pac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/arm64/pauth/pac.c b/tools/testing/selftests/arm64/pauth/pac.c
index b743daa772f55..5a07b3958fbf2 100644
--- a/tools/testing/selftests/arm64/pauth/pac.c
+++ b/tools/testing/selftests/arm64/pauth/pac.c
@@ -182,6 +182,9 @@ int exec_sign_all(struct signatures *signed_vals, size_t val)
 		return -1;
 	}
 
+	close(new_stdin[1]);
+	close(new_stdout[0]);
+
 	return 0;
 }
 
-- 
2.43.0



