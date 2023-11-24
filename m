Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E7A339BE;
	Fri, 24 Nov 2023 18:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nes/L+ZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BBFC433C7;
	Fri, 24 Nov 2023 18:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851745;
	bh=AuTHNQJArfiePYyiUZ711FXIlCR24TqLtKVnlcx3Il0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nes/L+ZNKTkMFAJA4DyQYVEwprVMp3a/OzQ1z5STvZfUn5le91VTeFPXZ5mmtC7tt
	 42ektKTQwHTqWOhyjUzeEQ8UDMIkbcKslFeehdjvWwUHtKwzm1scumw21+qxxBckVY
	 JMjRsQl5jorBhJZNlY/ii6pBmVePya2Nbh/cGvp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhujun2 <zhujun2@cmss.chinamobile.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/372] selftests/efivarfs: create-read: fix a resource leak
Date: Fri, 24 Nov 2023 17:47:21 +0000
Message-ID: <20231124172012.281251725@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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



