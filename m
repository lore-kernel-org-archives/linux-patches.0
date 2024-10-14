Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DAF1AA7AB;
	Mon, 14 Oct 2024 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919807; cv=none; b=XJLS3EvcTcYlLWqdj7uhJFZOaFQCle7U2E5ajaOAwug411WE/+JNXhDxJzBfNVee6yOXTe6I50XlrgG3hdmt8UEw71DHR576xZe6L6JqzF8kA85LM3b0YZMJ7dWQvkPW6YrCnNIL7HcukJRGF0dabTtB6GLnid/+20y1PjYJY+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919807; c=relaxed/simple;
	bh=oQh/LF993gN5SU9H5+DmDSRtzN1vIe3uoRKgGE8cYWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FEkS/CyBg4maB8G8oDiCwfmdFBMCKlF2/sLlO3JMqsRPghmx88MF6cLCvhZBUbpGErvRX6bgKgMbPvOd7Z5VEi0Epo1+PUlrUrjM+5rlVPeHKzRpFMcEprpFbLad24AdF1iIt87naqnctXeEsFXJDbiCopGpUXctQVK1JNuqWVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFpaNErR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFpaNErR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329E2C4CEC3;
	Mon, 14 Oct 2024 15:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919807;
	bh=oQh/LF993gN5SU9H5+DmDSRtzN1vIe3uoRKgGE8cYWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFpaNErRTVv0MtrRi0+LVck6qdnbX3nEU4lXgUHD7epIQQuVwl+qaan6x5nXZGmEW
	 ceAkECGgUxqjDVVAR1vaefEkTkJzG7etO0B/ThEY4xNFXXq8edx2WLa4HcSYs6/dam
	 0hhsMg+/3ZqWArRW1gExwOl6RpbCUPt7oYgP7T2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 713/798] comedi: ni_routing: tools: Check when the file could not be opened
Date: Mon, 14 Oct 2024 16:21:07 +0200
Message-ID: <20241014141246.078741518@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Ruffalo Lavoisier <ruffalolavoisier@gmail.com>

[ Upstream commit 5baeb157b341b1d26a5815aeaa4d3bb9e0444fda ]

- After fopen check NULL before using the file pointer use

Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
Link: https://lore.kernel.org/r/20240906203025.89588-1-RuffaloLavoisier@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c b/drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c
index d55521b5bdcb2..892a66b2cea66 100644
--- a/drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c
+++ b/drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c
@@ -140,6 +140,11 @@ int main(void)
 {
 	FILE *fp = fopen("ni_values.py", "w");
 
+	if (fp == NULL) {
+		fprintf(stderr, "Could not open file!");
+		return -1;
+	}
+
 	/* write route register values */
 	fprintf(fp, "ni_route_values = {\n");
 	for (int i = 0; ni_all_route_values[i]; ++i)
-- 
2.43.0



