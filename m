Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20F839FD9;
	Fri, 24 Nov 2023 18:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKfgSEAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC70C433C7;
	Fri, 24 Nov 2023 18:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848860;
	bh=C6CfkuKX+mjrR66d0MT3vqUxVh94gVtCY9/34RwQ4yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKfgSEAHkJGwCLTK5lWJ55UlSIvfwJ4H2psMY+pHuvaYj3Lmq/Pc72T0c3trr54T8
	 cxztP20i/sz2NTVkS3d1L5l1xf//mCs0+TTlUo+BbAOMEXs1wUcr4aAPwpKWu1h6lX
	 Ji2g4hVLUdDDi+xDiHgxP3SdXCSTYf1boi/1dJ8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhujun2 <zhujun2@cmss.chinamobile.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 11/57] selftests/efivarfs: create-read: fix a resource leak
Date: Fri, 24 Nov 2023 17:50:35 +0000
Message-ID: <20231124171930.707356793@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171930.281665051@linuxfoundation.org>
References: <20231124171930.281665051@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhujun2 <zhujun2@cmss.chinamobile.com>

[ Upstream commit 3f6f8a8c5e11a9b384a36df4f40f0c9a653b6975 ]

The opened file should be closed in main(), otherwise resource
leak will occur that this problem was discovered by code reading

Signed-off-by: zhujun2 <zhujun2@cmss.chinamobile.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/efivarfs/create-read.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/efivarfs/create-read.c b/tools/testing/selftests/efivarfs/create-read.c
index 9674a19396a32..7bc7af4eb2c17 100644
--- a/tools/testing/selftests/efivarfs/create-read.c
+++ b/tools/testing/selftests/efivarfs/create-read.c
@@ -32,8 +32,10 @@ int main(int argc, char **argv)
 	rc = read(fd, buf, sizeof(buf));
 	if (rc != 0) {
 		fprintf(stderr, "Reading a new var should return EOF\n");
+		close(fd);
 		return EXIT_FAILURE;
 	}
 
+	close(fd);
 	return EXIT_SUCCESS;
 }
-- 
2.42.0



