Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068E11D04B4;
	Wed,  2 Oct 2024 14:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880589; cv=none; b=X+ICPkzTXsbkejTMim7wxHZrnPH+cxJjoyGMSpG38+YWJkYF3QaOjXaXQOctfaqZhVbeT3vzaoImIeMZ4Cj1t9clbcecMXzRAOicvJ46nvSZ5pL+R08aJ8OXptHmNQocst7rLeBCUS4SIWWode6PdhSO6voZ0uOPC47ZwhVrOec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880589; c=relaxed/simple;
	bh=pDJLA60Q1Q/OyZSIzR8HjmlNB037AKE/88el8iqwJXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opmFuKEKc6UwfaPWh84GnnVUcA1ZbiINYi+oT4inwEn/TFrprT68WW2Ln8QXdgj/6YyZuZ9cTwv4aQSvBfTBs1Us/+IpidnhC++izo17h4S5ZfDno3zY999b1NrZXfLubInKV+6OoFHCH70iOpWnPZRt6oDg1FA+IgxGjdVo1ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2c41Ka3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2c41Ka3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838B1C4CEC2;
	Wed,  2 Oct 2024 14:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880588;
	bh=pDJLA60Q1Q/OyZSIzR8HjmlNB037AKE/88el8iqwJXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2c41Ka3SNc+9AoEpB10L+InpD97KwsVLk2RA+Z9bb6rKJibaVisGMAg8ye1IY8QQy
	 AVt+hhNNA4SWg05m+mzkL0X3RSy+HzfRbZG3+h6jmsF/8hjo+2rVhPDupt9WtUBY7S
	 GDPPDQNeZnxKVQiW9HZclNYXT+JgbY2vMfDutdM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"qin.wan@hp.com, andreas.noever@gmail.com, michael.jamet@intel.com, mika.westerberg@linux.intel.com, YehezkelShB@gmail.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, Alexandru Gagniuc" <alexandru.gagniuc@hp.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Qin Wan <qin.wan@hp.com>,
	Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Subject: [PATCH 6.6 511/538] thunderbolt: Introduce tb_for_each_upstream_port_on_path()
Date: Wed,  2 Oct 2024 15:02:30 +0200
Message-ID: <20241002125812.613853152@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 956c3abe72fb6a651b8cf77c28462f7e5b6a48b1 ]

This is useful when walking over upstream lane adapters over given path.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Qin Wan <qin.wan@hp.com>
Signed-off-by: Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -1076,6 +1076,21 @@ static inline bool tb_port_use_credit_al
 	for ((p) = tb_next_port_on_path((src), (dst), NULL); (p);	\
 	     (p) = tb_next_port_on_path((src), (dst), (p)))
 
+/**
+ * tb_for_each_upstream_port_on_path() - Iterate over each upstreamm port on path
+ * @src: Source port
+ * @dst: Destination port
+ * @p: Port used as iterator
+ *
+ * Walks over each upstream lane adapter on path from @src to @dst.
+ */
+#define tb_for_each_upstream_port_on_path(src, dst, p)			\
+	for ((p) = tb_next_port_on_path((src), (dst), NULL); (p);	\
+	     (p) = tb_next_port_on_path((src), (dst), (p)))		\
+		if (!tb_port_is_null((p)) || !tb_is_upstream_port((p))) {\
+			continue;					\
+		} else
+
 int tb_port_get_link_speed(struct tb_port *port);
 int tb_port_get_link_generation(struct tb_port *port);
 int tb_port_get_link_width(struct tb_port *port);


