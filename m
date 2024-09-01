Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8FD1C68C;
	Sun,  1 Sep 2024 16:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208699; cv=none; b=SsNWBqcKptuaHPHUAVVLxXHSqy5PR/u58GMfzAYh6DtITpijjga2REMmOTGFN6SzRu2+YqWaIMhxNKulf9M5vyeOr0E8K173oiwLCIx2M1T8ZHOToXw964E3BUGU5dx+9j89XIbCzLBkaGXwb3pdWW5eYGjs0SKr3A6jPBHp1Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208699; c=relaxed/simple;
	bh=49Q23zQHiIodSv8xO3eGG7CJNN+wU/dISJg4JfFqcMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bM9HOof999uxKf1GbUfecYqPMC0ZLaYrpPZ7pZC4bqOw2xibqQrVvhFAyz9I1ukZ8j9pPwtYvJJBFyI4EbjCoXD2npqIjSwC+5OV5/YJUZMa9WXbLzmhnzLw7cKzLmn5pT6QAh6h8JfKLSuu/J5zY7012zeXp6KGwEQ7yG5MJY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hWV33ez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hWV33ez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0907C4CEC3;
	Sun,  1 Sep 2024 16:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208699;
	bh=49Q23zQHiIodSv8xO3eGG7CJNN+wU/dISJg4JfFqcMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hWV33ezJXxhTSyYPOmnS6h5sp6vqpjKbX/lQ4b00ffbSaZ128LJ04EKJdxJUJFY4
	 lJeQAav+6peF/79Q4+wM8k/URFTrBvL9x3i0299B+yaKqfvlrJn/zWyWn+z8AKdwhK
	 5ztwGKFL1+1+zLJIHJGl3qvCF1Gk10gztxwh4Jtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.4 013/134] memcg_write_event_control(): fix a user-triggerable oops
Date: Sun,  1 Sep 2024 18:15:59 +0200
Message-ID: <20240901160810.611953724@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 046667c4d3196938e992fba0dfcde570aa85cd0e upstream.

we are *not* guaranteed that anything past the terminating NUL
is mapped (let alone initialized with anything sane).

Fixes: 0dea116876ee ("cgroup: implement eventfd-based generic API for notifications")
Cc: stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4732,9 +4732,12 @@ static ssize_t memcg_write_event_control
 	buf = endp + 1;
 
 	cfd = simple_strtoul(buf, &endp, 10);
-	if ((*endp != ' ') && (*endp != '\0'))
+	if (*endp == '\0')
+		buf = endp;
+	else if (*endp == ' ')
+		buf = endp + 1;
+	else
 		return -EINVAL;
-	buf = endp + 1;
 
 	event = kzalloc(sizeof(*event), GFP_KERNEL);
 	if (!event)


