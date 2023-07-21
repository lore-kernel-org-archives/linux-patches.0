Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A896720F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A543C433C7;
	Fri, 21 Jul 2023 19:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967617;
	bh=wA0prljJF1cN1cCMaff2uIYX4Q9AnQ0u0FuY9KEZGdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KixE8IekwDOzmUJkfhu/Vj0J7srBsW8IhlV72yaaMA8CiatFZCtpYhz3tToZZFt+2
	 CppoJ9y4/I3f5siRZKCVnzyv0wPkaafXSB4JSMlpv4EzZT1MEblpE46KYhw8FBx7zf
	 cF/rMkplD2togPgh7Q9D9ngQpsL2UtzZbKZpzxO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beau Belgrave <beaub@linux.microsoft.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 204/223] tracing/user_events: Fix struct arg size match check
Date: Fri, 21 Jul 2023 18:07:37 +0200
Message-ID: <20230721160529.572184399@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Beau Belgrave <beaub@linux.microsoft.com>

commit d0a3022f30629a208e5944022caeca3568add9e7 upstream.

When users register an event the name of the event and it's argument are
checked to ensure they match if the event already exists. Normally all
arguments are in the form of "type name", except for when the type
starts with "struct ". In those cases, the size of the struct is passed
in addition to the name, IE: "struct my_struct a 20" for an argument
that is of type "struct my_struct" with a field name of "a" and has the
size of 20 bytes.

The current code does not honor the above case properly when comparing
a match. This causes the event register to fail even when the same
string was used for events that contain a struct argument within them.
The example above "struct my_struct a 20" generates a match string of
"struct my_struct a" omitting the size field.

Add the struct size of the existing field when generating a comparison
string for a struct field to ensure proper match checking.

Link: https://lkml.kernel.org/r/20230629235049.581-2-beaub@linux.microsoft.com

Cc: stable@vger.kernel.org
Fixes: e6f89a149872 ("tracing/user_events: Ensure user provided strings are safely formatted")
Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_user.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -707,6 +707,9 @@ static int user_field_set_string(struct
 	pos += snprintf(buf + pos, LEN_OR_ZERO, " ");
 	pos += snprintf(buf + pos, LEN_OR_ZERO, "%s", field->name);
 
+	if (str_has_prefix(field->type, "struct "))
+		pos += snprintf(buf + pos, LEN_OR_ZERO, " %d", field->size);
+
 	if (colon)
 		pos += snprintf(buf + pos, LEN_OR_ZERO, ";");
 


