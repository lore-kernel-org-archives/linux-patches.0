Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF8F28EA7B;
	Wed, 23 Apr 2025 15:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420553; cv=none; b=rM5GYMCVmroNK8Q0NtC3JgXSfvYFx0scw/9Ff2RKM/Ba+HQHGsmYmCK5FcJkyF30MRhTTTW+kkqWu0kMmA5IYcMyT+2SQh3kgJDdM7b5LThXAw7QbJbM+leOuGOXFucyRgxXe3zMTpyhNRkcneaj9e7m3itEpqi0Bdlfe6MCiUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420553; c=relaxed/simple;
	bh=o9HKI+QLk5PKW8QBw/i41HMWwMFl7y6eAlJ/fus7HSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByKeAWVofHfGmbktjqplsZxhwyxfjzeKNqTUjUjTGxdK6Qhsirv7SVLrObuIkj9W4HwA6s2602FkjKj2NBz5XipLEjtOUOYnxZh7cBOB3wrMWtRmyC5x/8UgKiJuigZr1NLV4sYzhGKwS1zDPGq7d50O4EQItip/fffyWr/jH7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0UYqRNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0UYqRNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C970C4CEE2;
	Wed, 23 Apr 2025 15:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420553;
	bh=o9HKI+QLk5PKW8QBw/i41HMWwMFl7y6eAlJ/fus7HSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0UYqRNgF2lUqLzDc6e2LP6LTHQpIBpDYoiFAgc2jKa/50Ul651zSuLEudteUDW83
	 AjdfeqyRPqOT3HJkYyCsxuSmeF14U/LRNoYJAY5cuDhnI7qJp/NagIA4U2P6RE77eB
	 +kzr1TclzuS54OVh9MavjXsBm5k1gzqaO5IAGCA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriele Paoloni <gpaoloni@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/393] tracing: fix return value in __ftrace_event_enable_disable for TRACE_REG_UNREGISTER
Date: Wed, 23 Apr 2025 16:39:44 +0200
Message-ID: <20250423142646.933189569@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Paoloni <gpaoloni@redhat.com>

[ Upstream commit 0c588ac0ca6c22b774d9ad4a6594681fdfa57d9d ]

When __ftrace_event_enable_disable invokes the class callback to
unregister the event, the return value is not reported up to the
caller, hence leading to event unregister failures being silently
ignored.

This patch assigns the ret variable to the invocation of the
event unregister callback, so that its return value is stored
and reported to the caller, and it raises a warning in case
of error.

Link: https://lore.kernel.org/20250321170821.101403-1-gpaoloni@redhat.com
Signed-off-by: Gabriele Paoloni <gpaoloni@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 562efd6685726..1a936978c2b1a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -790,7 +790,9 @@ static int __ftrace_event_enable_disable(struct trace_event_file *file,
 				clear_bit(EVENT_FILE_FL_RECORDED_TGID_BIT, &file->flags);
 			}
 
-			call->class->reg(call, TRACE_REG_UNREGISTER, file);
+			ret = call->class->reg(call, TRACE_REG_UNREGISTER, file);
+
+			WARN_ON_ONCE(ret);
 		}
 		/* If in SOFT_MODE, just set the SOFT_DISABLE_BIT, else clear it */
 		if (file->flags & EVENT_FILE_FL_SOFT_MODE)
-- 
2.39.5



