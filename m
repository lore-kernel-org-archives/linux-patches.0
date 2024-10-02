Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6151D0DD6;
	Wed,  2 Oct 2024 14:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878540; cv=none; b=R4eI8LtP8xRGDHOomlvoV5dmMlc3p5cpkjeSVJiA3Au2+pT9P35dxuYNkXg/OzkrLV/mi68gz9kgjDTxC304kCbWzMWx8UWE0YOtH614jTdddIDp3lAdwYVBnHC6vvSV2tiu2sXwYEpcu0growXu6T+rErL12Zr703dHVH53bog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878540; c=relaxed/simple;
	bh=juHw6+hCY1+y86H0XuqCVYqZf181AYYh0+vcvBGNp4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJdNecQHNiGXbyup8jS573jQPKlVTdCyMm4Vjf/l1NQEGI2gYgPIBygUGO4r+d/cEp48oy6/BdIBQZPAmn6O5xBbt8m4KR5br2KxvpKeVkwH+zxjpMiKhKvllsMIGkx4Plp/LhBVRgCMQ4/Uq0M/MmyvDRR093ZE4BKIMKIsI2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rY9ZktWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rY9ZktWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA303C4CEC2;
	Wed,  2 Oct 2024 14:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878540;
	bh=juHw6+hCY1+y86H0XuqCVYqZf181AYYh0+vcvBGNp4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rY9ZktWdPjXYefeubVBU++ClsRVaIMApHOhKsERGP9Z6lIuJevcuKI9LVoIfV5qEG
	 CrIn/kyfKYfyS6fPd+LwFI4QigmtfuMiUprYqaiZuUW8QqJR9VuJ85VtD4v9I8dZsn
	 G848lCoaDxX8NeMotLy5dmEJHe9oiVnZ857IanVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 449/634] selftests: netfilter: Avoid hanging ipvs.sh
Date: Wed,  2 Oct 2024 14:59:09 +0200
Message-ID: <20241002125828.822330796@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit fc786304ad9803e8bb86b8599bc64d1c1746c75f ]

If the client can't reach the server, the latter remains listening
forever. Kill it after 5s of waiting.

Fixes: 867d2190799a ("selftests: netfilter: add ipvs test script")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/netfilter/ipvs.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/netfilter/ipvs.sh b/tools/testing/selftests/net/netfilter/ipvs.sh
index 4ceee9fb39495..d3edb16cd4b3f 100755
--- a/tools/testing/selftests/net/netfilter/ipvs.sh
+++ b/tools/testing/selftests/net/netfilter/ipvs.sh
@@ -97,7 +97,7 @@ cleanup() {
 }
 
 server_listen() {
-	ip netns exec "$ns2" socat -u -4 TCP-LISTEN:8080,reuseaddr STDOUT > "${outfile}" &
+	ip netns exec "$ns2" timeout 5 socat -u -4 TCP-LISTEN:8080,reuseaddr STDOUT > "${outfile}" &
 	server_pid=$!
 	sleep 0.2
 }
-- 
2.43.0



