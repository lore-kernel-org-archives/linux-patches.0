Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED86718DF86;
	Tue, 10 Sep 2024 10:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964570; cv=none; b=uvhBfhZDic+tjbvel+lQ1zBaOl+8SE8pz1sh0UWMt5lYGE5j8b2WBtnraBr5yYJASKdqSfZwxHRQvbTKiCrJa1lx7yMon5Wt2m1B+G7BUQNaYzCSdAih9bzTpO+Jvc+X4fZy/h+k42zcQjA3bk6jIDYRlrqQswpivvx+Q+ed3c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964570; c=relaxed/simple;
	bh=1yg84wNLohepaJpqh4cvdt8Yy/L8QJOmCgFzg9wuEI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I54OnG42qDKVcz9k+do0htfo1DyMUeP5e5HgwLGKmenOAu//3MhqNikwaPg5hSJP3z/pdIzGhZUqoSx7enu2GI3OY+eCDuf154Ni1dDlA8OVOlJmXIKg17hM6d0bW0fCUaIp1SwEa0ViTbzdStX42W+9xm9GoX8B4bNDh5m0UaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zP0X/vcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zP0X/vcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D87C4CEC3;
	Tue, 10 Sep 2024 10:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964569;
	bh=1yg84wNLohepaJpqh4cvdt8Yy/L8QJOmCgFzg9wuEI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zP0X/vcwXcGc/1MCd3Ty7vY4EVMXxZQCo+1xUYqg4YrUFTcWV8WxlJkj3yhMjzN7G
	 hw2gKLNY57JgepBRWxRZlNUOg3XiHGnirJ36KTXCZEPQ8Omk96SbnIHKVSQPYXU5JF
	 OLaXFW52lhr6wQB8M1AQRbVgVleVk+RKEQSjUFtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 227/269] workqueue: wq_watchdog_touch is always called with valid CPU
Date: Tue, 10 Sep 2024 11:33:34 +0200
Message-ID: <20240910092616.028440993@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit 18e24deb1cc92f2068ce7434a94233741fbd7771 ]

Warn in the case it is called with cpu == -1. This does not appear
to happen anywhere.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 8c7bafbee1b1..a1665c2e04b4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -6458,6 +6458,8 @@ notrace void wq_watchdog_touch(int cpu)
 {
 	if (cpu >= 0)
 		per_cpu(wq_watchdog_touched_cpu, cpu) = jiffies;
+	else
+		WARN_ONCE(1, "%s should be called with valid CPU", __func__);
 
 	wq_watchdog_touched = jiffies;
 }
-- 
2.43.0



