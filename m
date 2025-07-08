Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093322E612D;
	Tue,  8 Jul 2025 16:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993106; cv=none; b=ohe/kVdSZhVRIzpeUWRPL5/iy6cUfT3jPgpan0g0ZJ0dvSauacu4O3GLvSeR0wjFwThCnkDyu3ps9AHja+COb87PEdo116bHI9zQxbkUc6BIotedlLdAt153VoRqZsQwqioS5AWcxWIc4XQClIvUfuK7s+tMtvxzMNwl8nmjFDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993106; c=relaxed/simple;
	bh=VshMK0DPnmdMw/opns/mcGqckfX9Ub3zIp1ZuW1dOGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtdcWMzmJPERJB60/jjXJ9hBipJE0HzWNIHVGLqAniBbYd18bW2vghCPj3AfZ+JN6Jrc1okX7qwk6QPYJKyjfY72m3eZ4HZXucwoFZPyfZw5J/1wciZjbAVmWwJ22lPcJWWqlG1SN05PghQQbcI2UNJ5tjGvCVXHXzbK/IPakoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IzsUI2lf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IzsUI2lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79EC7C4AF09;
	Tue,  8 Jul 2025 16:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993105;
	bh=VshMK0DPnmdMw/opns/mcGqckfX9Ub3zIp1ZuW1dOGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IzsUI2lfeImvXHNdc9Ljapzxga7wO0iDznNETpFb9a00Pmt2kNgj2YVLEdVg1IZP7
	 9IZ3+zyaqL0qSyuGWoDQg2fujWAvXZJCEe3Dr1AMT4XBkrz6KJymvjb/pt54Az2Aem
	 YieT0J5Rv4h5HiBYwlfJC3eiq89+3vYYjsHoBmBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 189/232] rcu: Return early if callback is not specified
Date: Tue,  8 Jul 2025 18:23:05 +0200
Message-ID: <20250708162246.381120120@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uladzislau Rezki (Sony) <urezki@gmail.com>

[ Upstream commit 33b6a1f155d627f5bd80c7485c598ce45428f74f ]

Currently the call_rcu() API does not check whether a callback
pointer is NULL. If NULL is passed, rcu_core() will try to invoke
it, resulting in NULL pointer dereference and a kernel crash.

To prevent this and improve debuggability, this patch adds a check
for NULL and emits a kernel stack trace to help identify a faulty
caller.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index cefa831c8cb32..552464dcffe27 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3076,6 +3076,10 @@ __call_rcu_common(struct rcu_head *head, rcu_callback_t func, bool lazy_in)
 	/* Misaligned rcu_head! */
 	WARN_ON_ONCE((unsigned long)head & (sizeof(void *) - 1));
 
+	/* Avoid NULL dereference if callback is NULL. */
+	if (WARN_ON_ONCE(!func))
+		return;
+
 	if (debug_rcu_head_queue(head)) {
 		/*
 		 * Probable double call_rcu(), so leak the callback.
-- 
2.39.5



